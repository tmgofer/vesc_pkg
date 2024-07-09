; Copyright 2024 Mateusz Nowik   (mateusz1.nowik@gmail.com)
;
; This file is intended to be used in VESC firmware based devices.
;
; The VESC firmware is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.



 
; ==== User Settings section ==== 
(define volume      0.05)    ; Volume
(define min_rpm     10000.0) ; Minimum rpm to start exerting load [rpm]
(define max_rpm     50000.0) ; rpm at which braking with nominal current will occur [rpm]
; ==== End of User Settings section ==== 


; Internal values - edit only if you know what you're doing!  
(define loop_freq 100.0)     ; Main loop frequency [Hz]
(define loop_dt (/ 1 loop_freq)) ; Main loop delay
(define curr_factor (/ 1 (- max_rpm min_rpm))) ; 

; Play music for a start
(foc-beep 200 0.1 volume)
(foc-beep 250 0.1 volume)
(foc-beep 300 0.1 volume)
(foc-beep 400 0.2 volume)
(foc-beep 300 0.1 volume)
(foc-beep 400 0.3 volume)

; ---------- MAIN PROGRAM ---------- 
(loopwhile t
    (progn
        
        (sleep loop_dt)
    
        ; Measure the rpm
        (setvar 'actual_rpm (get-rpm))
        
        ; Calculate current based on actual rpm:
        (setvar 'brake 0) ; For lower than min rpm
        (if (> actual_rpm min_rpm) ; Between min and max rpm
            (setvar 'brake (* curr_factor (- actual_rpm min_rpm)))
        )
        (if (> actual_rpm max_rpm) ; Over max rpm
            (setvar 'brake 1)
        )
        
        ; Command braking
        (set-brake-rel brake)
    )
)