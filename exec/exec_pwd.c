#include "../includes/exec.h"

void	ft_pwd(void)
{
	ft_putstr_fd(g_pwd_path, 1);
	write(1, "\n", 1);
}
