#include "../includes/parsing.h"

int			count_valid_str(char **input_array)
{
	int size;
	int array_count;

	array_count = 0;
	size = 0;
	while (input_array[array_count])
	{
		if ((input_array[array_count][0]))
			size++;
		array_count++;
	}
	return (size);
}

char		**clean_array(char **input_array)
{
	int		size;
	int		add_count;
	int		array_count;
	char	**output_array;

	array_count = 0;
	size = count_valid_str(input_array);
	if (!(output_array = (char **)malloc(sizeof(char*) * (size + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	array_count = 0;
	add_count = 0;
	while (input_array[array_count])
	{
		if ((input_array[array_count][0]))
		{
			output_array[add_count] = ft_strdup(input_array[array_count]);
			add_count++;
		}
		array_count++;
	}
	output_array[add_count] = NULL;
	free_str_array(input_array);
	return (output_array);
}

char		*clean_cmd(char *input_str)
{
	if (input_str)
	{
		free_str(&input_str);
		if (g_lst->raw[0])
			input_str = ft_strdup(g_lst->raw[0]);
	}
	return (input_str);
}

void		clear_tab(char ***pt_tab)
{
	int i;

	i = 0;
	while (pt_tab[0][i])
	{
		pt_tab[0][i] = clear_it(pt_tab[0][i]);
		i++;
	}
}

void		clear_str(char **pt_str)
{
	*pt_str = clear_it(*pt_str);
}
