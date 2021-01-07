
#include "../includes/exec.h"

int		length_with_status(char *input_str, char *status)
{
	int total;

	total = ft_strlen(input_str) - 2;
	total += ft_strlen(status);
	total++;
	return (total);
}

char	*create_str_with_exit(char *input_str, int index, int status)
{
	int		output_length;
	char	*output_str;
	char	*str_status;

	str_status = ft_itoa(status);
	output_length = length_with_status(input_str, str_status);
	if (!(output_str = (char *)malloc(sizeof(char) * output_length)))
		ft_error('\0', "Malloc", NULL, 1);
	output_str = ft_strncpy(output_str, input_str, index);
	output_str = ft_strcat(output_str, str_status);
	output_str = ft_strcat(output_str, &input_str[index + 2]);
	free_str(&str_status);
	free_str(&input_str);
	return (output_str);
}

int		replace_symbol(char **raw_array, int array_count,
						int str_count, int status)
{
	raw_array[array_count] = create_str_with_exit(raw_array[array_count]
	, str_count, status);
	if (array_count == 0)
	{
		free_str(&g_lst->cmd);
		g_lst->cmd = ft_strdup(raw_array[array_count]);
	}
	else
	{
		free_str(&g_lst->arg[array_count - 1]);
		g_lst->arg[array_count - 1] = ft_strdup(raw_array[array_count]);
	}
	return (0);
}

void	replace_exit_status(int status)
{
	int		array_count;
	int		str_count;
	char	**raw_array;
	char	*map;

	array_count = 0;
	raw_array = g_lst->raw;
	while (raw_array[array_count])
	{
		str_count = 0;
		while (raw_array[array_count][str_count])
		{
			map = map_quote(raw_array[array_count]);
			if (raw_array[array_count][str_count] == '$'
			&& map[str_count] != '1'
			&& !is_esc(raw_array[array_count], str_count)
			&& raw_array[array_count][str_count + 1] == '?')
				str_count = replace_symbol(raw_array
				, array_count, str_count, status);
			else
				str_count++;
			free_str(&map);
		}
		array_count++;
	}
}
