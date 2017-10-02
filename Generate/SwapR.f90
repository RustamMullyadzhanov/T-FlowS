!======================================================================!
  SUBROUTINE SwapR(a,b) 
!----------------------------------------------------------------------!
!   Swaps two double precision reals.                                  !
!----------------------------------------------------------------------!
  IMPLICIT NONE
!-----------------------------[Parameters]-----------------------------!
  REAL :: a,b
!-------------------------------[Locals]-------------------------------!
  REAL :: t
!======================================================================!

  t=a
  a=b
  b=t

  END SUBROUTINE SwapR
