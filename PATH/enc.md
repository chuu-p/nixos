i could implement this with polymorphic executables


if $1 = decrypt
sudo cryptsetup luksOpen /dev/sda1 backup
sudo mkdir -p /run/media/Backup
sudo mount /dev/mapper/backup /run/media/Backup/

if $1 = encrypt
sudo umount /run/media/Backup
sudo cryptsetup luksClose backup

