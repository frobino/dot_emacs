;; This file is required (and should be customized only if we want to use ede)

(ede-cpp-root-project "project_root" ;; project name
                      :file "/dir/to/project_root/Makefile" ;; path to a file in the root folder
                      :include-path '("/include1"  
                                      "/include2") ;; add more include
                      ;; paths here
                      :system-include-path '("~/linux"))

;; (ede-cpp-root-project "NAME"
;; 		      :file "FILENAME"
;; 		      :include-path '( "/include" "../include" "/c/include" )
;; 		      :system-include-path '( "/usr/include/c++/3.2.2/" )
;; 		      :spp-table '( ("MOOSE" . "")
;; 				    ("CONST" . "const") ) )
