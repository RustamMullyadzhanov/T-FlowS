!======================================================================*
      PROGRAM b2a 
!----------------------------------------------------------------------*
!  Converts binary files NAME.geo and NAME.cns to ascii.              *
!----------------------------------------------------------------------*
      implicit none
!======================================================================*

  real,allocatable :: xc(:),yc(:),zc(:)
  real,allocatable :: Sx(:),Sy(:),Sz(:)
  real,allocatable :: volume(:)            ! cell's volume
  real,allocatable :: delta(:)             ! delta (max(dx,dy,dz))
  real,allocatable :: Dx(:),Dy(:),Dz(:)
  real,allocatable :: xsp(:),ysp(:),zsp(:) ! face coordinates
  real,allocatable :: WallDs(:), f(:)

  character :: name*80

  integer   :: NC, NS                    ! num. of nodes and cells
  integer   :: NbC, Ncopy, NSsh, Nmat

  integer,allocatable :: material(:)     ! material markers
  integer,allocatable :: SideC(:,:)      !  c0, c1, c2

  integer,allocatable :: TypeBC(:)       ! type of boundary condition

  integer,allocatable :: CopyC(:)        !  might be shorter
  integer,allocatable :: CopyS(:,:)      !  similar to SideC

  integer      c, s
  character*80 nameIn
  character*80 namOut
!======================================================================*

  write(*,*) '# Input the problem name:'
  read(*,*)  name

!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
!     Read the binary file with the     *
!       connections between cells       *
!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
  nameIn=name
  nameIn(len_trim(name)+1:len_trim(name)+4)='.cns'
  open(9, FILE=nameIn,FORM='UNFORMATTED')
  write(*,*) '# Now reading the binary .cns file:', nameIn

!///// number of cells, boundary cells and sides 
  read(9) NC
  read(9) NbC
  read(9) NS
  read(9) NSsh
  read(9) Nmat

!///// cell materials
  allocate (material(-NbC:NC))
  read(9) (material(c), c=1,NC)
  read(9) (material(c), c=-1,-NBC,-1)

!///// sides
  allocate (SideC(0:2,NS))
  read(9) (SideC(0,s), s=1,NS)
  read(9) (SideC(1,s), s=1,NS)
  read(9) (SideC(2,s), s=1,NS)

!///// boundary cells
  allocate (TypeBC(-NbC:-1)); TypeBC=0
  allocate (CopyC(-NbC:-1));  CopyC=0
  read(9) (TypeBC(c), c=-1,-NbC, -1)
  read(9) (CopyC(c), c=-1,-NbC, -1)

!///// boundary copy cells
  read(9) Ncopy
  allocate (CopyS(2,Ncopy));
  write(*,*) Ncopy
  read(9) (CopyS(1,s), s=1,Ncopy)
  read(9) (CopyS(2,s), s=1,Ncopy)

  close(9)

!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
!     Writing the ascii file with the      *
!        connections between cells         *
!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
  namOut = name 
  namOut(len_trim(name)+1:len_trim(name)+4)='.cns'
  open(9, FILE=namOut)
  write(*,*) '# Now writing the ascii .cns file:', namOut

!///// number of cells
  write(9,*) NC
  write(9,*) NbC
  write(9,*) NS
  write(9,*) NSsh
  write(9,*) Nmat

  write(9,*) (material(c), c=1,NC)
  write(9,*) (material(c), c=-1,-NBC,-1)
 
!///// sides
  write(9,*) (SideC(0,s), s=1,NS)
  write(9,*) (SideC(1,s), s=1,NS)
  write(9,*) (SideC(2,s), s=1,NS)

!///// boundary cells
  write(9,*) (TypeBC(c), c=-1,-NbC, -1) 
  write(9,*) (CopyC(c), c=-1,-Nbc, -1) 

!///// boundary copy cells
  write(9,*) Ncopy
  write(9,*) (CopyS(1,s), s=1,Ncopy)
  write(9,*) (CopyS(2,s), s=1,Ncopy)

  close(9)

!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
!     Read the binary file with     *
!       geometrical quantities      *
!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
  nameIn = name 
  nameIn(len_trim(name)+1:len_trim(name)+4)='.geo'
  open(9, FILE=nameIn, FORM='UNFORMATTED')
  write(*,*) '# Now reading the binary .geo file:', nameIn

  allocate (xc(-NbC:NC))
  allocate (yc(-NbC:NC))
  allocate (zc(-NbC:NC))
  allocate (volume(-NbC:NC))
  allocate (delta(-NbC:NC))
  allocate (WallDs(NS))
  allocate (Sx(NS))
  allocate (Sy(NS))
  allocate (Sz(NS))
  allocate (Dx(NS))
  allocate (Dy(NS))
  allocate (Dz(NS))
  allocate (f(NS))
  allocate (xsp(NS))
  allocate (ysp(NS))
  allocate (zsp(NS))

  read(9) (xc(c), c=1,NC)
  read(9) (yc(c), c=1,NC) 
  read(9) (zc(c), c=1,NC)
  read(9) (xc(c), c=-1,-NBC,-1)  
  read(9) (yc(c), c=-1,-NBC,-1)
  read(9) (zc(c), c=-1,-NBC,-1) 
  read(9) (volume(c), c=1,NC)
  read(9) (delta(c), c=1,NC)
  read(9) (WallDs(c), c=1,NC)
  read(9) (Sx(s), s=1,NS)
  read(9) (Sy(s), s=1,NS)
  read(9) (Sz(s), s=1,NS)
  read(9) (Dx(s), s=1,NS)
  read(9) (Dy(s), s=1,NS)
  read(9) (Dz(s), s=1,NS)
  read(9) (f(s), s=1,NS)
  read(9) (xsp(s), s=1,NS)
  read(9) (ysp(s), s=1,NS)
  read(9) (zsp(s), s=1,NS)

  close(9) 

!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
!     Write the ascii file with     *
!       geometrical quantities      *
!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
  namOut = name 
  namOut(len_trim(name)+1:len_trim(name)+4)='.geo'
  open(9, FILE=namOut)
  write(*,*) '# Now writing the ascii .geo file:', namOut

  write(9,'(E24.16)') (xc(c), c=1,NC)
  write(9,'(E24.16)') (yc(c), c=1,NC) 
  write(9,'(E24.16)') (zc(c), c=1,NC)
  write(9,'(E24.16)') (xc(c), c=-1,-NBC,-1)  
  write(9,'(E24.16)') (yc(c), c=-1,-NBC,-1)
  write(9,'(E24.16)') (zc(c), c=-1,-NBC,-1) 
  write(9,'(E24.16)') (volume(c), c=1,NC)
  write(9,'(E24.16)') (delta(c), c=1,NC)
  write(9,'(E24.16)') (WallDs(c), c=1,NC)
  write(9,'(E24.16)') (Sx(s), s=1,NS)
  write(9,'(E24.16)') (Sy(s), s=1,NS)
  write(9,'(E24.16)') (Sz(s), s=1,NS)
  write(9,'(E24.16)') (Dx(s), s=1,NS)
  write(9,'(E24.16)') (Dy(s), s=1,NS)
  write(9,'(E24.16)') (Dz(s), s=1,NS)
  write(9,'(E24.16)') (f(s), s=1,NS)
  write(9,'(E24.16)') (xsp(s), s=1,NS)
  write(9,'(E24.16)') (ysp(s), s=1,NS)
  write(9,'(E24.16)') (zsp(s), s=1,NS)

  close(9) 

  end PROGRAM
