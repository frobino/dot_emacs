;; To retrieve completion candidates for your projects,
;; you will have to tell Clang where your include paths are.
;; Create a file named .dir-locals.el at your project root
;; If you put a file with a special name .dir-locals.el in a directory,
;; Emacs will read it when it visits any file in that directory or any of its subdirectories,
;; and apply the settings it specifies to the file’s buffer
;;
;; THIS FILE EXPANDS COMPANY-CLANG backend
;;
(
 (nil . ((company-clang-arguments . ("-I/home/<user>/project_root/include1/"
                                     "-I/home/<user>/project_root/include2/")
                                  )
         ;; The following line enables Flycheck to compile headers and move on to
         ;; show errors in buffer.
         (flycheck-clang-include-path . ("/home/<user>/project_root/include1/"                         
                                         "/home/<user>/project_root/include2/")
                                  )

         )
 )
)
;; NOTE: Windows users:
;;
;; (
;;  (nil . ((company-clang-arguments . ("-Ie:/Tmp/github/c-demo-project/include1"                         
;;                                      "-Ie:/Tmp/github/c-demo-project/include2"                         
;;                                      "-Ie:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/include")
;;                                   )
;;          (flycheck-clang-include-path . ("e:/Tmp/github/c-demo-project/include1"                         
;;                                          "e:/Tmp/github/c-demo-project/include2"
;;                                          "e:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/include")
;;                                   )
;;          )
;;  )
;; )
