!======================================================================!
  subroutine CalcMn(n0, n1)   
!----------------------------------------------------------------------!
!   Calculates time averaged velocity and velocity fluctuations.       !
!----------------------------------------------------------------------!
!------------------------------[Modules]-------------------------------!
  use all_mod
  use pro_mod
  use les_mod
  use rans_mod
!----------------------------------------------------------------------!
  implicit none
!-----------------------------[Parameters]-----------------------------!
  integer :: n0, n1
!-------------------------------[Locals]-------------------------------!
  integer :: c, n
!======================================================================!

  n=n1-n0

  if(n  > -1) then
    do c=-NbC,NC
!-----------------------!
!      mean values      !
!-----------------------!
      U % mean(c) = ( U % mean(c) * (1.*n) + U % n(c) ) / (1.*(n+1))
      V % mean(c) = ( V % mean(c) * (1.*n) + V % n(c) ) / (1.*(n+1))
      W % mean(c) = ( W % mean(c) * (1.*n) + W % n(c) ) / (1.*(n+1))
      P % mean(c) = ( P % mean(c) * (1.*n) + P % n(c) ) / (1.*(n+1))

!------------------------------!
!      fluctuating values      !
!------------------------------!
      uu % mean(c) = ( uu % mean(c)*(1.*n) + U % n(c) * U % n(c) ) & 
                   / (1.*(n+1))
      vv % mean(c) = ( vv % mean(c)*(1.*n) + V % n(c) * V % n(c) ) & 
                   / (1.*(n+1))
      ww % mean(c) = ( ww % mean(c)*(1.*n) + W % n(c) * W % n(c) ) & 
                   / (1.*(n+1))

      uv % mean(c) = ( uv % mean(c)*(1.*n) + U % n(c) * V % n(c) ) & 
                   / (1.*(n+1))
      uw % mean(c) = ( uw % mean(c)*(1.*n) + U % n(c) * W % n(c) ) & 
                   / (1.*(n+1))
      vw % mean(c) = ( vw % mean(c)*(1.*n) + V % n(c) * W % n(c) ) & 
                   / (1.*(n+1))

!      VISt_mean(c) = ( VISt_mean(c)*(1.*n) + VISt(c) ) & 
!                   / (1.*(n+1))

      if(HOT==YES) then
        T % mean(c) = ( T % mean(c) * (1.*n) + T % n(c) ) / (1.*(n+1))
        TT % mean(c) = ( TT % mean(c)*(1.*n) + T % n(c) * T % n(c) ) & 
                     / (1.*(n+1))
        uT % mean(c) = ( uT % mean(c)*(1.*n) + u % n(c) * T % n(c) ) & 
                     / (1.*(n+1))
        vT % mean(c) = ( vT % mean(c)*(1.*n) + v % n(c) * T % n(c) ) & 
                     / (1.*(n+1))
        wT % mean(c) = ( wT % mean(c)*(1.*n) + w % n(c) * T % n(c) ) & 
                     / (1.*(n+1))
      end if
    end do 
  end if

  RETURN 

  end subroutine CalcMn
