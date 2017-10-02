!======================================================================!
  SUBROUTINE CalcVISt_KepsV2F() 
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
!------------------------------[Calling]-------------------------------!
!-------------------------------[Locals]-------------------------------!
  INTEGER :: c, c1, c2, s
  REAL    :: UnorSq, Unor, UtotSq, Cmu1, beta, Prmol, Prturb
  REAL    :: lf, Gblend, Ustar, Ck, yPlus, Uplus, EBF
!======================================================================!

  call Scale()

  if(SIMULA == K_EPS_VV) then
    do c = 1,NC
      VISt(c) = CmuD*v_2%n(c)*Tsc(c)
    end do
  else if(SIMULA == ZETA) then
    do c = 1,NC
      VISt(c) = CmuD*v_2%n(c)*Kin % n(c)*Tsc(c)
    end do
  else if(SIMULA == HYB_ZETA) then
    do c = 1,NC
      VISt(c) = CmuD*v_2%n(c)*Kin % n(c)*Tsc(c)
      VISt_eff(c) = max(VISt(c),VISt_sgs(c))
    end do
    call Exchng(VISt_eff)  
  end if

  do s=1,NS
    c1=SideC(1,s)
    c2=SideC(2,s)
    
    if(c2 < 0 .and. TypeBC(c2) /= BUFFER) then
      if(TypeBC(c2)==WALL .or. TypeBC(c2)==WALLFL) then

        Uf(c1)  = Cmu**0.25*Kin%n(c1)**0.5

        if(ROUGH == YES) then
          Ynd(c1) = (WallDs(c1)+Zo)*Uf(c1)/VISc
        else if(ROUGH == NO) then
          Ynd(c1) = WallDs(c1)*Uf(c1)/VISc 
        end if

        Uf(c1)  = Cmu**0.25*Kin%n(c1)**0.5
        Ynd(c1) = WallDs(c1)*Uf(c1)/VISc 
        Gblend  = 0.01*Ynd(c1)**4.0/(1.0+5.0*Ynd(c1))

        Yplus = Ynd(c1)  !max(Ynd(c1),1.1)
        Uplus = log(Yplus*Elog)/(kappa)
   
        if(Yplus< 3.0) then
          VISwall(c1) = VISt(c1) + VISc  
        else
          VISwall(c1) = Ynd(c1)*VISc/(Yplus*exp(-1.0*Gblend) &
                        +Uplus*exp(-1.0/Gblend) + TINY)
        end if

        if(ROUGH == YES) then
          Uplus = log((WallDs(c1)+Zo)/Zo)/(kappa + TINY) + TINY
          VISwall(c1) = min(Yplus*VISc*kappa/LOG((WallDs(c1)+Zo)/Zo),1.0e+6*VISc)
       end if

        if(HOT==YES) then
          Prturb = 1.0 / ( 0.5882 + 0.228*VISt(c1)/VISc   &
                 - 0.0441 * (VISt(c1)/VISc)**2.0  &
                 * (1.0 - exp(-5.165*VISc/(VISt(c1)+tiny))) )
          Prmol = VISc * CAPc(material(c1)) / CONc(material(c1))
          beta = 9.24 * ((Prmol/Prturb)**0.75 - 1.0) * (1.0 + 0.28 * exp(-0.007*Prmol/Prturb))
          EBF = 0.01 * (Prmol*Yplus)**4.0 / (1.0 + 5.0 * Prmol**3.0 * Yplus) + TINY
          CONwall(c1) = Yplus*VISc*CAPc(material(c1))/(Yplus*Prmol*exp(-1.0 * EBF) &
                      + (Uplus + beta)*Prturb*exp(-1.0/EBF) + TINY)
        end if
      end if  ! TypeBC(c2)==WALL or WALLFL
    end if    ! c2 < 0
  end do
 
  call Exchng(VISt)  
  call Exchng(VISwall)  
  RETURN

  END SUBROUTINE CalcVISt_KepsV2F  
