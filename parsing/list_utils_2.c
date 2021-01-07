
#include "../includes/parsing.h"

int	is_only_space(char *stock)
{
	int i;

	i = 0;
	while (stock[i])
	{
		if (stock[i] != ' ')
			return (1);
		i++;
	}
	return (0);
}

int	is_pipe(char *stock)
{
	int	i;

	i = 0;
	while (stock[i])
	{
		if (stock[i] == '|' && !is_esc(stock, i))
			return (1);
		i++;
	}
	return (0);
}
