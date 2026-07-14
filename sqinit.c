#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/loop.h>
#include <linux/module.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#define finit_module(fd, param_values, flags)                                  \
  syscall(SYS_finit_module, fd, param_values, flags)

const char dirs[][5] = {"/sqs", "/wrk", "/upp", "/mnt"};

void panic(char *message) {
  struct dirent *entry;
  perror(message);
  printf("current dirs are:\n");
  DIR *currentdir = opendir(".");
  while ((entry = readdir(currentdir)) != NULL) {
    printf("%s\n", entry->d_name);
  }
  sleep(100);
  exit(1);
}

int main(void) {
  int loop_ctl_fd, loop_id, sqsh_fd, mod_fd, loop_fd;
  char *loopdev;

  // create mount points
  for (size_t i = 0; i < sizeof(dirs) / sizeof(dirs[0]); i++)
    mkdir(dirs[i], 600);

  // remove self
  remove("/init");

  // mount devtmpfs since we need it
  if (mount("devtmpfs", "/dev", "devtmpfs", 0, ""))
    panic("failed to mount devtmpfs");

  // load included kernel modules
  if (chdir("/mods/"))
    panic("failed to enter /mods/");

  DIR *moddir = opendir(".");
  struct dirent *mod;

  while ((mod = readdir(moddir)) != NULL) {
    if (mod->d_name[0] == '.')
      continue;
    mod_fd = open(mod->d_name, 0);
    if (mod_fd == -1) {

      fprintf(stderr, "failed to open %s as file\n", mod->d_name);
      panic("");
      return 1;
    }
    if (finit_module(mod_fd, "", MODULE_INIT_COMPRESSED_FILE)) {
      if (errno == EEXIST)
        continue;
      fprintf(stderr, "failed to load module %s\n", mod->d_name);
      panic("");
    }
    close(mod_fd);
    if (unlink(mod->d_name))
      perror("could not delete module");
  }

  chdir("/");
  rmdir("/mods");

  // get ourselvs a loop device (like the ID ain't gonna be 0 but don't wanna fw
  // it)
  loop_ctl_fd = open("/dev/loop-control", O_RDWR);
  if (loop_ctl_fd == -1)
    panic("can't open /dev/loop-control");
  loop_id = ioctl(loop_ctl_fd, LOOP_CTL_GET_FREE);
  if (loop_id == -1)
    panic("can't get loop device");

  close(loop_ctl_fd);
  printf("got loop with id %d\n", loop_id);

  // set the loop device to the squashfs file
  sqsh_fd = open("/rootfs.sqsh", O_RDONLY);
  if (sqsh_fd == -1) {
    panic("can't open rootfs.sqsh");
  }
  asprintf(&loopdev, "/dev/loop%d", loop_id);
  printf("loopdev path is: %s\n", loopdev);

  loop_fd = open(loopdev, O_RDWR);
  if (loop_fd == -1)
    panic("can't open loopdev");

  if (ioctl(loop_fd, LOOP_SET_FD, sqsh_fd))
    panic("failed to set fd to loopdev");

  close(sqsh_fd);
  close(loop_fd);
  printf("setup loop\n");

  // first mount layer
  if (mount(loopdev, "/sqs", "squashfs", MS_RDONLY,
            "errors=panic,threads=multi"))
    panic("mount failed");
  printf("mounted squashfs on /sqs\n");
  free(loopdev);

  // remove /dev
  umount("/dev");
  unlink("/dev/console");
  rmdir("/dev/");

  if (mount("overlay", "/mnt", "overlay", 0,
            "lowerdir=/sqs,upperdir=/upp,workdir=/wrk,redirect_dir=on"))
    panic("failed to mount overlayfs");
  printf("mounted overlay on /mnt\n");

  //// only enable with debug=true
  // execl("/busybox", "/busybox", "sh", NULL);

  chroot("/mnt");
  chdir("/");
  printf("chrooted to rootfs fs\n");

  if (mount("devtmpfs", "/dev", "devtmpfs", 0, ""))
    perror("failed to mount devtmpfs");
  if (mount("proc", "/proc", "proc", 0, ""))
    perror("failed to mount procfs");
  if (mount("sysfs", "/sys", "sysfs", 0, ""))
    perror("failed to mount sysfs");
  printf("mounted virtual filesystems\n");

  execl("/sbin/init", "/sbin/init", NULL);
}
