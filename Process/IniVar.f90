!======================================================================!
  subroutine IniVar 
!----------------------------------------------------------------------!
!   Initialize dependent variables                                     !
!----------------------------------------------------------------------!
!------------------------------[Modules]-------------------------------!
  use all_mod
  use pro_mod
  use les_mod
  use par_mod
  use rans_mod
!----------------------------------------------------------------------!
  implicit none
!------------------------------[Calling]-------------------------------!
  real    :: UserUPlus, Uta, Stot
!-------------------------------[Locals]-------------------------------!
  integer :: c, c1, c2, m, s, n
  integer :: N1, N2, N3, N4, N5, N6
!======================================================================!
  Area  = 0.0
  Uaver = 0.0
  do n=1,Nmat
    do c=1,NC
      U % mean(c) = 0.0
      V % mean(c) = 0.0
      W % mean(c) = 0.0
      U % n(c)    = U % init(material(c))
      U % o(c)    = U % init(material(c)) 
      U % oo(c)   = U % init(material(c))
      V % n(c)    = V % init(material(c)) 
      V % o(c)    = V % init(material(c))
      V % oo(c)   = V % init(material(c))
      W % n(c)    = W % init(material(c)) 
      W % o(c)    = W % init(material(c))
      W % oo(c)   = W % init(material(c))
      if(HOT==YES) then
        T % n(c)  = T % init(material(c)) 
        T % o(c)  = T % init(material(c)) 
        T % oo(c) = T % init(material(c)) 
        Tinf      = T % init(material(c))
      end if 
      if(SIMULA==EBM.or.SIMULA==HJ) then
        uu % n(c)  = uu % init(material(c))
        vv % n(c)  = vv % init(material(c))
        ww % n(c)  = ww % init(material(c))
        uv % n(c)  = uv % init(material(c))
        uw % n(c)  = uw % init(material(c))
        vw % n(c)  = vw % init(material(c))
        Eps % n(c) = Eps % init(material(c))
        if(SIMULA==EBM) f22 % n(c) = f22 % init(material(c))
      end if
      if(SIMULA==K_EPS.or.SIMULA==HYB_PITM) then
        Kin % n(c)  = Kin % init(material(c))
        Kin % o(c)  = Kin % init(material(c))
        Kin % oo(c) = Kin % init(material(c))
        Eps % n(c)  = Eps % init(material(c))
        Eps % o(c)  = Eps % init(material(c))
        Eps % oo(c) = Eps % init(material(c))
        Uf(c)       = 0.047
        Ynd(c)      = 30.0
      end if
      if(SIMULA==K_EPS_VV.or.SIMULA==ZETA.or.SIMULA==HYB_ZETA) then
        Kin % n(c)    = Kin % init(material(c))
        Kin % o(c)    = Kin % init(material(c))
        Kin % oo(c)   = Kin % init(material(c))
        Eps % n(c)  =   Eps % init(material(c))
        Eps % o(c)  =   Eps % init(material(c))
        Eps % oo(c) =   Eps % init(material(c))
        f22 % n(c)  =   f22 % init(material(c))
        f22 % o(c)  =   f22 % init(material(c))
        f22 % oo(c) =   f22 % init(material(c))
        v_2 % n(c)  =   v_2 % init(material(c))
        v_2 % o(c)  =   v_2 % init(material(c))
        v_2 % oo(c) =   v_2 % init(material(c))
        Uf(c)       =   0.047
         Ynd(c)      =   30.0
      end if
      if(SIMULA == SPA_ALL .or. SIMULA==DES_SPA) then      
        VIS % n(c)    = VIS % init(material(c))
        VIS % o(c)    = VIS % init(material(c))
        VIS % oo(c)   = VIS % init(material(c))
      end if
    end do 
  end do   !end do n=1,Nmat

  if(TGV == YES) then
    do c=1,NC
      U % n(c)    = -sin(xc(c))*cos(yc(c))
      U % o(c)    = -sin(xc(c))*cos(yc(c))
      U % oo(c)   = -sin(xc(c))*cos(yc(c))
      V % n(c)    = cos(xc(c))*sin(yc(c))
      V % o(c)    = cos(xc(c))*sin(yc(c))
      V % oo(c)   = cos(xc(c))*sin(yc(c))
      W % n(c)    = 0.0
      W % o(c)    = 0.0
      W % oo(c)   = 0.0
      P % n(c)    = 0.25*(cos(2*xc(c)) + cos(2*yc(c)))
    end do
  end if

!=====================================!
!        Calculate the inflow         !
!     and initializes the Flux(s)     ! 
!     at both inflow and outflow      !
!=====================================!
  N1 = 0
  N2 = 0
  N3 = 0
  N4 = 0
  N5 = 0
  N6 = 0
  do m=1,Nmat
    MassIn(m) = 0.0
    do s=1,NS
      c1=SideC(1,s)
      c2=SideC(2,s)
      if(c2  < 0) then 
        Flux(s) = DENc(material(c1))*( U % n(c2) * Sx(s) + &
                                       V % n(c2) * Sy(s) + &
                                       W % n(c2) * Sz(s) )
                                       
        if(TypeBC(c2)  ==  INFLOW) then
          if(material(c1) == m) MassIn(m) = MassIn(m) - Flux(s) 
          Stot  = sqrt(Sx(s)**2 + Sy(s)**2 + Sz(s)**2)
          Area  = Area  + Stot
        endif
        if(TypeBC(c2)  ==  WALL)     N1=N1+1 
        if(TypeBC(c2)  ==  INFLOW)   N2=N2+1  
        if(TypeBC(c2)  ==  OUTFLOW)  N3=N3+1 
        if(TypeBC(c2)  ==  SYMMETRY) N4=N4+1 
        if(TypeBC(c2)  ==  WALLFL)   N5=N5+1 
        if(TypeBC(c2)  ==  CONVECT)  N6=N6+1 
      else
        Flux(s) = 0.0 
      end if
    end do
    call iglsum(N1)
    call iglsum(N2)
    call iglsum(N3)
    call iglsum(N4)
    call iglsum(N5)
    call iglsum(N6)
    call glosum(MassIn(m))
    call glosum(Area)
  end do                  

!==========================!
!     Initializes Time     ! 
!==========================!
  Time   = 0.0   
  Uaver  = MassIn(1)/Area 
!   write(*,*) MassIn, Area, MassIn/Area 
!>>> This is very handy test to perform 
  if(this  < 2) then
    write(*,*) '# MassIn=', MassIn(1)
    write(*,*) '# Average inflow velocity =', MassIn(1)/Area
    write(*,*) '# Number of faces on the wall        : ',N1
    write(*,*) '# Number of inflow faces             : ',N2
    write(*,*) '# Number of outflow faces            : ',N3
    write(*,*) '# Number of symetry faces            : ',N4
    write(*,*) '# Number of faces on the heated wall : ',N5
    write(*,*) '# Number of convective outflow faces : ',N6

    write(*,*) '# Variables initialized !'
  end if

  RETURN

  end subroutine IniVar
