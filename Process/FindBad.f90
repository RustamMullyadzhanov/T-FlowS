!======================================================================!
  subroutine FindBad()
!----------------------------------------------------------------------!
! Searches for cells which are "bad" for calculation of pressure       !
! gradients.                                                           !
!                                                                      !
! Practically, these are the tetrahedronal cells with two faces on the !
! boundary and two in the domain.                                      ! 
!----------------------------------------------------------------------!
!------------------------------[Modules]-------------------------------!
  use all_mod
  use pro_mod
  use par_mod
!----------------------------------------------------------------------!
  implicit none
!-------------------------------[Locals]-------------------------------!
  integer :: s, c, c1, c2, NumBad
!======================================================================!

  BadForG = .FALSE. 
  NumGood = 0

  NumBad = 0

  do s=1,NS
    c1=SideC(1,s)
    c2=SideC(2,s)
    if(c2 < 0) then
      NumGood(c1) = NumGood(c1) + 1 
    end if  
  end do

  do c=1,NC
    if(NumGood(c)==2) then
      BadForG(c) = .TRUE.
      NumBad = NumBad + 1
    end if
  end do 

  NumGood = 0
  
  call IGlSum(NumBad)

  if(THIS < 2) write(*,*) '# There are ', NumBad, &
                          ' bad cells for gradients.'

  end subroutine FindBad
