program prueba_lapack
  use module_matrix
  integer,parameter:: n=2,lwmax=1000,LDA = N, LDVL = N, LDVR = N,m=3
  integer::info,lwork=-1
  double precision::alpha=1,beta=0,inva(n,n),b(n,m),c(n,m), a(n,n),wr(n),wi(n),work(lwmax),VL( LDVL, N ), VR( LDVR, N )
  double precision::AMAX, BMAX, CMAX

  a=reshape((/1.0,2.0,3.0,4.0 /),(/2,2/),order=(/2,1/))
  b=reshape((/2.0,3.0,4.0,5.0,6.0,7.0/),shape(b),order=(/2,1/))
  call print_matrix(n,n,a,'La recontraputa Matriz a')
  call print_matrix(n,m,b,'La recontraputa Matriz b')
  !inva=inv(a)
  !call dgeev('N','N',n,a,n,wr,wi,VL, LDVL, VR, LDVR, WORK, LWORK, INFO)
 ! LWORK = MIN( LWMAX, INT( WORK( 1 ) ) )
  !call dgeev('N','N',n,a,n,wr,wi,VL, LDVL, VR, LDVR, WORK, LWORK, INFO)

  !b=a+a
!call DGEMM('n','n',n,m,n,alpha,a,n,B,m,beta,c,m)


  C=prod(A,B) 
  call print_matrix(n,m,c,'a*b')
 
  
end program prueba_lapack
