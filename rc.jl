(defun add-to-list (path)
  "add path to load-path"
  (setq load-path (cons (expand-file-name path) load-path)))

(add-to-list "~/.sawfish")
(add-to-list "~/.sawfish/lisp")

;; 自己定义的宏
(defmacro my-setq (name value)
  "Declare the NAME as a variable and set its value to VALUE."
  `(progn (defvar ,name)
(setq ,name ,value)))

;; 自己定义的函数
(defun backgroundize (string)
  "Append a character `&' to STRING if it is not end with a `&'."
  (let ((len (length string)))
    (if (string= "&" (substring string (- len 1)))
string
      (concat string " &")))) ;; concat函数用于连接两个字符串

(defun make-entry (name-command)
  "Return a list represents a entry could be contained in a list represents a application menu."
  (list (car name-command)
(list 'system (backgroundize (cadr name-command)))))

(defun make-user-apps-menu (entry-list)
  "Create a list to be stored in variable user-apps-menu."
  (mapcar #'make-entry entry-list))

(defun call-startup-programs (command-list)
  "Run the programs specified in COMMAND-LIST when Sawfish start."
  (mapcar #'(lambda (command)
(system (backgroundize command)))
command-list))

(defun bind-global-key (bindings-list)
  "Bind a list of keystroke to the GLOBAL-KEYMAP."
  (mapcar #'(lambda (bindings)
(bind-keys global-keymap (nth 0 bindings) (nth 1 bindings)))
bindings-list))

(defun show-desktop-toggle ()
  "Show or hide the desktop."
  (if (showing-desktop-p)
      (hide-desktop)
    (show-desktop)))

(defun set-random-wallpaper (wallpapers)
  "Set the wallpaper randomly."
  (system (concat "habak -ms ~/picture/"
(nth (random (length wallpapers)) wallpapers))))

(defun turn-off-screen ()
  "Turn off the power of the screen."
  (system "xset dpms force off"))

(defun cons-jump-or-exec (lst)
  "Construct the list for the start up programs."
  (mapcar #'(lambda (entry)
(list (car entry)
(cons 'jump-or-exec (cdr entry))))
lst))

;; * 自己定义的变量
;; ** 我的应用程序菜单
(defvar *my-user-apps-menu* nil)
(setq *my-user-apps-menu*
  '(("Emacs" "emacs")
    ("_LyX" "lyx")
    ("Terminator" "terminator")
    ("_GNOME terminal" "gnome-terminal")
    ("_Shutter" "shutter")
    ("SMPlayer" "smplayer")
    ("Firefox" "firefox")
    ;; ("Comix" "comix")
    ("_DeaDBeef" "deadbeef")
    ("Evince" "evince")
    ("_File roller" "file-roller")
    ("_Nautilus" "nautilus")
    ;; ("Eog" "eog")
    ("磁盘实用工具(_P)" "palimpsest")
    ;; ("StarDict" "stardict")
    ("_Rox" "rox")
    ("GNOME system monitor" "gnome-system-monitor")
    ("G_Vim" "gvim")
    ("_Eclipse" "~/building/eclipse/eclipse -vm /home/liutos/installer/jdk1.6.0_26/bin/java")
    ("_MySQL-Workbench" "mysql-workbench")))
;; ** 我的桌面壁纸候选菜单
(defvar *my-wallpapers* nil)
(setq *my-wallpapers*
  '("苹果的宇宙.jpg"
    "电波女.jpg"
    "邻人部.jpg"
    "立华奏.jpg"
    "纯白交响曲.jpg"
    "Aurora.jpg"
    "Fedora壁纸.jpg"
    "Win95 OS娘.jpg"
    "湖边.jpg"
    "蘑菇云.jpg"
    "天.jpg"
    "凉宫春日.png"
    "星球.jpg"))
;; ** 我的开机自动运行的程序
(defvar *my-startup-programs* nil)
(setq *my-startup-programs*
  `("tint2"
    ;; "nm-applet"
    "gnome-volume-control-applet"
    ;; "conky"
    ;; "/home/liutos/src/lisp/librep/shebang.jl"
    ))
;; ** 我的应用程序快捷键设置
(defvar *my-apps-shortcut*
  (cons-jump-or-exec
   '(("Super-a" "aMule" "amule")
     ("Super-c" "Comix" "comix")
     ("Super-d" "星际译王" "stardict")
     ("Super-e" "emacs@liutos-laptop" "emacs")
     ("Super-f" "Vimperator" "~/building/firefox/firefox")
     ("Super-g" "Chromium" "chromium-browser")
     ("Super-m" "系统监视器" "gnome-system-monitor")
     ("Super-n" "sancho 0.9.4-59" "~/installer/sancho-0.9.4-59-linux-gtk-java/sancho")
     ("Super-o" "图像查看器" "eog")
     ("Super-p" "Document Viewer" "evince")
     ("Super-s" "SMPlayer" "smplayer")
     ("Super-S" "Shutter" "shutter")
     ("Super-t" "liutos@liutos-laptop" "terminator")
     ("Super-v" "VirtualBox Manager" "virtualbox")
     ("Super-w" "文件浏览器" "nautilus")
     ("Super-x" "Foxit Reader" "FoxitReader"))))

;; * 配置Sawfish，注释风格与我的.emacs文件一致
;; ** 设定变量
;; *** 阻止Sawfish自动根据*.desktop文件生成应用程序菜单
(my-setq apps-menu-autogen nil)
;; *** 让弹出窗口也有和普通窗口一样的框架
(my-setq decorate-transients t)
;; *** 启动边缘动作功能
;; (my-setq edge-actions-enabled t)
;; *** 新创建的窗口以居中的方式出现
(my-setq place-window-mode 'centered)
;; *** 设定自己的应用程序菜单
(my-setq user-apps-menu (make-user-apps-menu *my-user-apps-menu*))
;; ** 运行程序
;; *** 随机设定壁纸
(set-random-wallpaper *my-wallpapers*)
;; (system "habak -ms ~/picture/苹果的宇宙.jpg &")
;; *** 在Sawfish启动时运行的程序
(call-startup-programs *my-startup-programs*)
;; ** 设定键绑定
;; *** 为经常使用的应用程序设定快捷键
(require 'sawfish.wm.commands.jump-or-exec)
(bind-global-key *my-apps-shortcut*)
;; *** 绑定Super-F4组合键为安全地关闭窗口
(bind-keys window-keymap "Super-F4"
'delete-window-safely)
;; *** 绑定Super-F10组合键为最大化当前窗口
(bind-keys window-keymap "Super-F10"
'maximize-window-toggle)
;; *** 绑定Super-b组合键为调用turn-off-screen函数
(bind-keys window-keymap "Super-b"
'(turn-off-screen))
;; *** 绑定Super-b组合键为随机设定壁纸
;; (bind-keys global-keymap "Super-b"
;; '(set-random-wallpaper *my-wallpapers*))
;; *** 绑定Super-k组合键为显示或隐藏桌面
(bind-keys global-keymap "Super-k"
'(show-desktop-toggle))
;; *** 绑定Super-r组合键为调出Sawfish根菜单
(bind-keys global-keymap "Super-r"
'(popup-root-menu))
;; *** 将鼠标右键在桌面单击绑定为调出Sawfish的根菜单
(bind-keys root-window-keymap "button3-click1"
    '(popup-root-menu))
(require 'init-keymap)
