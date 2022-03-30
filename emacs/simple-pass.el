;;; simple-pass.el --- Interact with pass  -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Free Software Foundation, Inc.

;; Author: Omar Polo <op@omarpolo.com>
;; Version: 1.0
;; Package-Requires: ((emacs "25.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Simple wrapper for password-store without unnecessary dependencies.

;;; Code:

(defgroup simple-pass nil
  "Simple Pass."
  :group 'simple-pass)

(defcustom simple-pass-cmd "pass"
  "Path to the pass executable.")

(defcustom simple-pass-dir (expand-file-name ".password-store" (getenv "HOME"))
  "Path to the password-store repository")

(defun simple-pass--copy ()
  (let ((default-directory simple-pass-dir)
        (process-file-side-effects))
    (with-temp-buffer
      (when (zerop (process-file "find" nil (current-buffer) nil
                                 "." "-type" "f" "-iname" "*.gpg"))
        (goto-char (point-min))
        (cl-loop until (eobp)
                 collect (buffer-substring-no-properties
                          ;; skip ./
                          (+ 2 (line-beginning-position))
                          ;; skip .gpg
                          (- (line-end-position) 4))
                 do (forward-line +1))))))

(defun simple-pass--copy-cr ()
  "Completion read function for `simple-pass-copy'."
  (completing-read "Entry: " (simple-pass--copy)))

;;;###autoload
(defun simple-pass-copy (pass)
  "Copy the password for PASS in the `kill-ring'."
  (interactive (list (simple-pass--copy-cr)))
  (with-temp-buffer
    (when (zerop (process-file simple-pass-cmd nil nil nil
                               "show" "-c" pass))
      (message "copied password for %s" pass))))

(provide 'simple-pass)
;;; simple-pass.el ends here
