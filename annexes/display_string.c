
#include "../includes/exec.h"

void	ft_putchar_fd(char c, int fd)
{
	write(fd, &c, 1);
}

void	ft_putstr_fd(char *str, int fd)
{
	int	count;

	count = 0;
	while (str[count])
	{
		ft_putchar_fd(str[count], fd);
		count++;
	}
}

void	ft_putnbr_annex(int nb)
{
	if (nb >= 10)
		ft_putnbr_annex(nb / 10);
	else
	{
		ft_putchar_fd(nb + 48, 1);
		return ;
	}
	ft_putchar_fd((nb % 10) + 48, 1);
}

void	ft_putnbr(int nb)
{
	if (nb == -2147483648)
		ft_putstr_fd("-2147483648", 1);
	else if (nb < 0)
	{
		ft_putchar_fd('-', 1);
		ft_putnbr_annex(nb * -1);
	}
	else
		ft_putnbr_annex(nb);
}
