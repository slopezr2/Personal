subroutine str(k,s)
!   "Convert an integer to string."
    integer, intent(in) :: k
    character(len=20),intent(out)::s
    write (s, *) k
    s = adjustl(s)
end subroutine str
