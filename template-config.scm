;;;; Template for Guix config file
;; Choose your path:
;; 1. Setup your Guix OS after install and refer to this to make changes
;; 2. Setup Guix package manager and use this to start reconfiguring Guix
;;
(use-modules (gnu) (gnu system nss))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us" #:options '("ctl:nocaps")))
  (host-name "some-hostname")
  (users (cons* (user-account
                  (name "somename")
                  (comment "Your name")
                  (group "users")
                  (home-directory "/home/somename")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (packages
    (append
     (list
      "ratpoison"        ;desktop env
      "st"               ;lightweight term
      "emacs-next"       ;emacs27 - best version
      "openssh"          ;for ssh
      "nss-certs"        ;needed for https
      "gnupg"            ;managing gpg keys
      "lynx"             ;for simple reading, not needed
      "git"              ;main version control
      "font-gnu-unifont" ;main font
      "make"             ;for times when you need make
      "mpv"              ;for times when you need make
      "neofetch scrot"   ;for /r/unixporn
      %base-packages)))

  (services
    (append
      (list (service openssh-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))

  (mapped-devices
    (list (mapped-device
            (source
              (uuid "xxxxxxxxxxxxxxxx")) ;Use this only if you have cryptroot enabled
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems)))
