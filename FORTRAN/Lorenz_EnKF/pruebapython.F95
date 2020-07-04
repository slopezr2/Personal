program Prueba_python

  !USE modulo_distribucion_normal
  use module_matrix
  
  implicit none
  real*8,dimension(:,:)::mat(2,2),mat_read(4)
  real*8,dimension(:)::vect(4),vect2(2)
  
  integer::i,j
  mat(1,1)=1
  mat(1,2)=2
  mat(2,1)=3
  mat(2,2)=4

  vect(1)=1
  vect(2)=2
  vect(3)=3
  vect(4)=4

  
  
  call print_matrix(4,1,vect,'matriz vect')

  call randperm(4,2,vect,vect2)
  call print_matrix(2,1,vect2,'matriz vect permut')

  
  !mat=transpose(mat)
  !call print_matrix(2,2,mat,'matriz transpuesta')
  
 ! open(101,file='mat_python.dat',status='unknown')
  !write(101,*) ((mat(i,j),i=1,2),j=1,2)
  !close(101)

  !open(101,file='mat_python.dat',status='unknown')
  !read(101,*) ((mat_read(i,j),i=1,2),j=1,2)
  !close(101)
  !call print_matrix(2,2,mat_read,'matriz leida')
  
 end program Prueba_python
  
