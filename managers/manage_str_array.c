
#include "../includes/exec.h"

int		str_array_length(char **input_array)
{
	int count;

	count = 0;
	if (input_array)
		while (input_array[count])
			count++;
	else
		return (-1);
	return (count);
}

void	display_str_array(char **input_array)
{
	int count;

	count = 0;
	if (input_array)
	{
		while (input_array[count])
		{
			ft_putstr_fd(input_array[count], 1);
			write(1, "\n", 1);
			count++;
		}
	}
}

void	free_str_array(char **input_array)
{
	int count;

	count = 0;
	if (input_array)
	{
		while (input_array[count])
		{
			free(input_array[count]);
			input_array[count] = NULL;
			count++;
		}
		free(input_array);
		input_array = NULL;
	}
}
