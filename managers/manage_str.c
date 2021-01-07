
#include "../includes/exec.h"

int		find_car(char *str, char c)
{
	int count;

	count = 0;
	while (str[count])
	{
		if (str[count] == c)
			return (count);
		count++;
	}
	return (-1);
}

int		ft_strlen(const char *str)
{
	int count;

	count = 0;
	if (str)
	{
		while (str[count])
			count++;
		return (count);
	}
	return (-1);
}

void	free_str(char **str)
{
	if (*str)
	{
		free(*str);
		*str = NULL;
	}
}
