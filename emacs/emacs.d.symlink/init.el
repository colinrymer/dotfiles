;; Directories and file names
(setq clr-emacs-init-file (or load-file-name buffer-file-name))
(setq clr-emacs-config-dir
      (file-name-directory clr-emacs-init-file))
(setq user-emacs-directory clr-emacs-config-dir)
(setq clr-elisp-dir (expand-file-name "elisp" clr-emacs-config-dir))
(setq clr-elisp-external-dir
      (expand-file-name "vendor" clr-emacs-config-dir))
(setq clr-submodules-dir
      (expand-file-name "submodules" clr-emacs-config-dir))
(setq clr-init-dir
      (expand-file-name "init.d" clr-emacs-config-dir))

;; Load all elisp files in ./init.d
(if (file-exists-p clr-init-dir)
    (dolist (file (directory-files clr-init-dir t "\\.el$"))
      (load file)))

;; Set up 'custom' system
(setq custom-file (expand-file-name "emacs-customizations.el" clr-emacs-config-dir))
(load custom-file)
