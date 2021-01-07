
#include "../includes/exec.h"

int		int_array_length(int *input_array)
{
	int count;

	count = 0;
	if (input_array)
		while (input_array[count] != -1)
			count++;
	else
		return (-1);
	return (count);
}

void	display_int_array(int *input_array)
{
	int count;

	count = 0;
	while (input_array[count] != -1)
	{
		ft_putnbr(input_array[count]);
		write(1, "\n", 1);
		count++;
	}
}

void	free_int_array(int *input_array)
{
	if (input_array)
	{
		free(input_array);
		input_array = NULL;
	}
}

void	free_2d_int_array(int **input_array)
{
	int count;

	count = 0;
	if (input_array)
	{
		while (input_array[count][0] != -1)
		{
			free(input_array[count]);
			input_array[count] = NULL;
			count++;
		}
		free(input_array[count]);
		input_array[count] = NULL;
		free(input_array);
		input_array = NULL;
	}
}
