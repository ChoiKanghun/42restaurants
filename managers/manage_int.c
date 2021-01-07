
#include "../includes/exec.h"

int		nb_length(long nb)
{
	int	length;

	length = 0;
	if (nb == 0)
		return (1);
	while (nb > 0)
	{
		nb = nb / 10;
		length++;
	}
	return (length);
}

char	*ft_itoa(int nb)
{
	int		length;
	char	*output_str;

	length = nb_length(nb);
	if (!(output_str = (char*)malloc(sizeof(char) * (length + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	output_str[length] = '\0';
	if (nb == 0)
	{
		output_str[0] = 48;
	}
	else
	{
		while (nb > 0)
		{
			length--;
			output_str[length] = 48 + (nb % 10);
			nb = nb / 10;
		}
	}
	return (output_str);
}
