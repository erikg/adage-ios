# Adage-iOS
Simple demo of an iOS app written in swift that gets JSON from a server and displays it.
The server posting the JSON is an interface to the UNIX ``fortune'' database with the web interface at http://elfga.com/adage .

All told, this is about 2.5, maybe 3 hours of work including the server.

## License
GPL v2.0
Copyright (C) 2015-2016 ElfGA Software Solutions, LLC

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Server
The server is written in common lisp using the UCW framework and is built into the existing web-app at http://elfga.com/adage

Here is the relevant server code, if you're interested

    (defun 20-random (&key (count 20) (db "norm"))
      (let ((docs (alexandria:shuffle (cadr (db.find "adage" (kv (kv "db" db)) :limit 20000)))))
        (mapcar (lambda (x) (list db (get-element "id" x)
                                  (concatenate 'string (subseq (get-element "body" x) 0 (min (length (get-element "body" x)) 12)) "...")))
                (subseq docs 0 (min (length docs) count)))))
    
    (ucw::defentry-point "/raw/" (:application *adage-ucw-application* :with-call/cc 'nil) ()
      (elfga.wowrealmstatus::ajaxify)
      (cl-json:encode-json (mapcar (lambda (x) (list (cons "db" (car x)) (cons "id" (cadr x)) (cons "body" (caddr x)))) (20-random)) elfga::$stream))
    (ucw::defentry-point "/raw/([a-z0-9]*)/([0-9]*)" (:application *adage-ucw-application* :class ucw::regexp-dispatcher :with-call/cc 'nil) ()
      (elfga.wowrealmstatus::ajaxify)
      (let ((db (aref ucw::*dispatcher-registers* 0))
            (id (aref ucw::*dispatcher-registers* 1)))
        (cl-json:encode-json (list (cons "db" db) (cons "id" id) (cons "body" (get-fortune :db db :id id))) elfga::$stream)))

