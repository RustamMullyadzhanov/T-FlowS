!======================================================================!
  SUBROUTINE CalcVISt_SPA_ALL(n) 
!----------------------------------------------------------------------!
!   Computes the turbulent viscosity for RANS models.                  !
!----------------------------------------------------------------------!
!------------------------------[Modules]-------------------------------!
  USE all_mod
  USE pro_mod
  USE les_mod
  USE rans_mod
!----------------------------------------------------------------------!
  IMPLICIT NONE
!-------------------------------[Locals]-------------------------------!
  INTEGER :: c, n 
  REAL    :: Xrat, Fv1, lf, Cs 
!======================================================================!

  if(SIMULA == DES_SPA) then
    do c = 1,NC
      Xrat     = VIS % n(c)/VISc
      Fv1      = Xrat**3.0/(Xrat**3.0 + Cvis1**3.0)
      VISt(c)  = DENc(material(c)) * Fv1 * VIS % n(c)
    end do
  end if

  if(SIMULA == SPA_ALL) then
    do c = 1,NC
      Xrat     = VIS % n(c)/VISc
      Fv1      = Xrat**3.0/(Xrat**3.0 + Cvis1**3.0)
      VISt(c)  = DENc(material(c)) * Fv1 * VIS % n(c)
    end do
  end if

  call Exchng(VISt)  

  RETURN

  END SUBROUTINE CalcVISt_SPA_ALL
