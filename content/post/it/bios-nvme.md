---
title: "Опыт загрузки Nvme раздела на материнке без поддержки nvme"
date: 2018-04-19T08:13:57+03:00
Tags: ["nvme", "linux"]
draft: false
---

Взял себе материнку `asus p7h55-m` без поддержки `nvme` технологии.

При этом имел Samsung Evo 960 ssd, который до этого работал на другой материнке.

Получилось подружить его с этой таким способом:

1. Сделать arch linux live usb
2. Загрузиться в неё.
3. Найти ненужную флешку.
4. Отформатировать её для загрузки в MBR режиме: http://valleycat.org/linux/arch-usb.html?i=1#partition
5. Из live режима увидеть, что девайсы /dev/nvme* видны
6. Замаунтинтить / из nvme в какую-нибудь директорию
7. Подготовить окружение для chroot:

```
sudo mount -B /proc /nvme_root/proc
sudo mount -B /dev /nvme_root/dev
sudo mount -B /sys /nvme_root/sys
```
8. chroot /nvme_root
9. Замаунтить раздели из отформатированной флешки с шага (4) в /boot.
10. Поправить /etc/fstab, чтобы /boot имел корректный uuid.
11. Добавить `nvme` в `MODULES` из `/etc/mkinitcpio.conf`.
12. Пересобрать `initramfs`: `mkinitcpio -p linux`
13. Сделать `grub-install --target=i386-pc --boot-directory /boot /dev/sdX`
14. И последнее: `grub-mkconfig -o /boot/grub/grub.cfg`
15. Готово.

У меня был затык в шаге 11, я не знал почему `grub2` не может загрузить ядро с рутом на nvme.

Но потом нашёл вот этот пост:

https://bbs.archlinux.org/viewtopic.php?id=212861

Там как раз было сказано про добавление `nvme` в `MODULES`, после этого всё взлетело.


Ссылки:

https://askubuntu.com/questions/3402/how-to-move-boot-and-root-partitions-to-another-drive


