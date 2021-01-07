
#include "../includes/parsing.h"

void	parsing(char *line)
{
	char **stock;

	check(line);
	stock = split_plus(line, ';');
	list_it(stock);
	if (stock)
	{
		free(stock);
		stock = NULL;
	}
}
