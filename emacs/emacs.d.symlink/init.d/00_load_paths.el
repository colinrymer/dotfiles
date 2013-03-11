;; Add my personal elisp directory to load path
(add-to-list 'load-path clr-elisp-dir)

; Add external projects to load path
(add-to-list 'load-path clr-elisp-external-dir)
(dolist (project (directory-files clr-submodules-dir t "\\w+"))
  (when (file-directory-p project)
        (add-to-list 'load-path project)))
