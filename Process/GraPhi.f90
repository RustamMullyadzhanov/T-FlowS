!======================================================================!
  subroutine GraPhi(PHI, i, PHIi, Boundary)
!----------------------------------------------------------------------!
! Calculates gradient of generic variable PHI by a least squares       !
! method.                                                              !
!----------------------------------------------------------------------!
!------------------------------[Modules]-------------------------------!
  use all_mod
  use pro_mod
!----------------------------------------------------------------------!
  implicit none
!-----------------------------[Parameters]-----------------------------!
  integer :: i
  real    :: PHI(-NbC:NC), PHIi(-NbC:NC) 
  logical :: Boundary
!-------------------------------[Locals]-------------------------------!
  integer :: s, c, c1, c2
  real    :: DPHI1, DPHI2, Dxc1, Dyc1, Dzc1, Dxc2, Dyc2, Dzc2 
!======================================================================!

!  return

  call Exchng(PHI)


  do c=1,NC
    PHIi(c)=0.0
  end do

  if(i == 1) then
    do s=1,NS
      c1=SideC(1,s)
      c2=SideC(2,s)
      Dxc1 = Dx(s)
      Dyc1 = Dy(s)
      Dzc1 = Dz(s)
      Dxc2 = Dx(s)
      Dyc2 = Dy(s)
      Dzc2 = Dz(s)
      DPHI1 = PHI(c2)-PHI(c1) 
      DPHI2 = PHI(c2)-PHI(c1) 
      if(c2 < 0 .and. TypeBC(c2) == SYMMETRY) then
        DPHI1 = 0.0  
        DPHI2 = 0.0  
      end if

!---- Take care of material interfaces           ! 2mat
!      if( StateMat(material(c1))==FLUID .and. &  ! 2mat
!          StateMat(material(c2))==SOLID       &  ! 2mat
!          .or.                                &  ! 2mat
!          StateMat(material(c1))==SOLID .and. &  ! 2mat
!          StateMat(material(c2))==FLUID ) then   ! 2mat
!        Dxc1 = xsp(s)-xc(c1)                     ! 2mat
!        Dyc1 = ysp(s)-yc(c1)                     ! 2mat
!        Dzc1 = zsp(s)-zc(c1)                     ! 2mat
!        Dxc2 = xsp(s)-xc(c2)                     ! 2mat
!        Dyc2 = ysp(s)-yc(c2)                     ! 2mat
!        Dzc2 = zsp(s)-zc(c2)                     ! 2mat
!        DPHI1 = 0.0-PHI(c1)                      ! 2mat
!        DPHI2 = 0.0-PHI(c2)                      ! 2mat 
!      end if                                     ! 2mat
              
      if(Boundary) then
        PHIi(c1)=PHIi(c1)+DPHI1*(G(1,c1)*Dxc1+G(4,c1)*Dyc1+G(5,c1)*Dzc1) 
        if(c2 > 0) then
	  PHIi(c2)=PHIi(c2)+DPHI2*(G(1,c2)*Dxc2+G(4,c2)*Dyc2+G(5,c2)*Dzc2)
        end if
      else
        if(c2 > 0 .or. c2 < 0 .and. TypeBC(c2) == BUFFER ) & 
                    PHIi(c1)=PHIi(c1)+DPHI1*(G(1,c1)*Dxc1+G(4,c1)*Dyc1+G(5,c1)*Dzc1) 
	if(c2 > 0)  PHIi(c2)=PHIi(c2)+DPHI2*(G(1,c2)*Dxc2+G(4,c2)*Dyc2+G(5,c2)*Dzc2)
      end if ! Boundary
    end do
  end if

  if(i == 2) then
    do s=1,NS
      c1=SideC(1,s)
      c2=SideC(2,s)
      Dxc1 = Dx(s)
      Dyc1 = Dy(s)
      Dzc1 = Dz(s)
      Dxc2 = Dx(s)
      Dyc2 = Dy(s)
      Dzc2 = Dz(s)
      DPHI1 = PHI(c2)-PHI(c1) 
      DPHI2 = PHI(c2)-PHI(c1) 
      if(c2 < 0 .and. TypeBC(c2) == SYMMETRY) then
        DPHI1 = 0.0  
        DPHI2 = 0.0  
      end if

!---- Take care of material interfaces           ! 2mat
!      if( StateMat(material(c1))==FLUID .and. &  ! 2mat
!          StateMat(material(c2))==SOLID       &  ! 2mat
!          .or.                                &  ! 2mat
!          StateMat(material(c1))==SOLID .and. &  ! 2mat
!          StateMat(material(c2))==FLUID ) then   ! 2mat
!        Dxc1 = xsp(s)-xc(c1)                     ! 2mat
!        Dyc1 = ysp(s)-yc(c1)                     ! 2mat
!        Dzc1 = zsp(s)-zc(c1)                     ! 2mat
!        Dxc2 = xsp(s)-xc(c2)                     ! 2mat
!        Dyc2 = ysp(s)-yc(c2)                     ! 2mat
!        Dzc2 = zsp(s)-zc(c2)                     ! 2mat
!        DPHI1 = 0.0-PHI(c1)                      ! 2mat
!        DPHI2 = 0.0-PHI(c2)                      ! 2mat 
!      end if                                     ! 2mat

      if(Boundary) then
        PHIi(c1)=PHIi(c1)+DPHI1*(G(4,c1)*Dxc1+G(2,c1)*Dyc1+G(6,c1)*Dzc1) 
        if(c2  > 0) then
	  PHIi(c2)=PHIi(c2)+DPHI2*(G(4,c2)*Dxc2+G(2,c2)*Dyc2+G(6,c2)*Dzc2)
        end if
      else
        if(c2 > 0 .or. c2 < 0 .and. TypeBC(c2) == BUFFER ) & 
                    PHIi(c1)=PHIi(c1)+DPHI1*(G(4,c1)*Dxc1+G(2,c1)*Dyc1+G(6,c1)*Dzc1) 
        if(c2  > 0) PHIi(c2)=PHIi(c2)+DPHI2*(G(4,c2)*Dxc2+G(2,c2)*Dyc2+G(6,c2)*Dzc2)
      end if ! Boundary
    end do
  end if

  if(i == 3) then
    do s=1,NS
      c1=SideC(1,s)
      c2=SideC(2,s)
      Dxc1 = Dx(s)
      Dyc1 = Dy(s)
      Dzc1 = Dz(s)
      Dxc2 = Dx(s)
      Dyc2 = Dy(s)
      Dzc2 = Dz(s)
      DPHI1 = PHI(c2)-PHI(c1) 
      DPHI2 = PHI(c2)-PHI(c1) 
      if(c2 < 0 .and. TypeBC(c2) == SYMMETRY) then
        DPHI1 = 0.0  
        DPHI2 = 0.0  
      end if

!---- Take care of material interfaces           ! 2mat
!      if( StateMat(material(c1))==FLUID .and. &  ! 2mat
!          StateMat(material(c2))==SOLID       &  ! 2mat
!          .or.                                &  ! 2mat
!          StateMat(material(c1))==SOLID .and. &  ! 2mat
!          StateMat(material(c2))==FLUID ) then   ! 2mat
!        Dxc1 = xsp(s)-xc(c1)                     ! 2mat
!        Dyc1 = ysp(s)-yc(c1)                     ! 2mat
!        Dzc1 = zsp(s)-zc(c1)                     ! 2mat
!        Dxc2 = xsp(s)-xc(c2)                     ! 2mat
!        Dyc2 = ysp(s)-yc(c2)                     ! 2mat
!        Dzc2 = zsp(s)-zc(c2)                     ! 2mat
!        DPHI1 = 0.0-PHI(c1)                      ! 2mat
!        DPHI2 = 0.0-PHI(c2)                      ! 2mat 
!      end if                                     ! 2mat 

      if(Boundary) then
        PHIi(c1)=PHIi(c1)+DPHI1*(G(5,c1)*Dxc1+G(6,c1)*Dyc1+G(3,c1)*Dzc1) 
        if(c2 > 0) then
	  PHIi(c2)=PHIi(c2)+DPHI2*(G(5,c2)*Dxc2+G(6,c2)*Dyc2+G(3,c2)*Dzc2)
        end if
      else
        if(c2 > 0 .or. c2 < 0 .and. TypeBC(c2) == BUFFER ) & 
                   PHIi(c1)=PHIi(c1)+DPHI1*(G(5,c1)*Dxc1+G(6,c1)*Dyc1+G(3,c1)*Dzc1) 
        if(c2 > 0) PHIi(c2)=PHIi(c2)+DPHI2*(G(5,c2)*Dxc2+G(6,c2)*Dyc2+G(3,c2)*Dzc2) 
      end if ! Boundary
    end do
  end if

  call Exchng(PHIi)

  if(.not. Boundary) call CorBad(PHIi)

  end subroutine GraPhi
