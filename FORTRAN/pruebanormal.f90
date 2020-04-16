program pruebanormal
 
  USE modulo_distribucion_normal
  implicit none
  integer*8::seed=2
  real*8,dimension(4,4):: a
  call r8mat_normal_01(4,4,seed,a)

  call r8mat_print(4,4,a,'La recontraputa')
  

end program pruebanormal
