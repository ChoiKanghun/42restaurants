#include "../includes/exec.h"

char	**duplicate_array(char **input_array, char **free_array, char sep)
{
	int		count;
	int		array_len;
	char	**output_array;
	char	**split_result;

	count = 0;
	array_len = str_array_length(input_array);
	if (!(output_array = (char **)malloc(sizeof(char *) * (array_len + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (input_array[count])
	{
		if (sep != '\0')
		{
			split_result = ft_split(input_array[count], sep);
			output_array[count] = ft_strdup(split_result[0]);
			free_str_array(split_result);
		}
		else
			output_array[count] = ft_strdup(input_array[count]);
		count++;
	}
	output_array[count] = NULL;
	if (free_array)
		free_str_array(free_array);
	return (output_array);
}

char	**sort_array(char **input_array)
{
	int		array_count;
	int		sort_count;
	char	*str_tmp;

	array_count = 0;
	while (input_array[array_count])
	{
		sort_count = array_count;
		while (input_array[sort_count + 1])
		{
			if ((ft_strcmp(input_array[sort_count]
			, input_array[sort_count + 1])) > 0)
			{
				str_tmp = input_array[sort_count];
				input_array[sort_count] = input_array[sort_count + 1];
				input_array[sort_count + 1] = str_tmp;
				sort_count = array_count;
			}
			else
				sort_count++;
		}
		array_count++;
	}
	return (input_array);
}

int		search_in_array(char **input_array, char *str, char sep)
{
	int		count;
	char	**split_result;

	count = 0;
	while (input_array[count])
	{
		if (sep != '\0')
		{
			split_result = ft_split(input_array[count], sep);
			if ((ft_strcmp(str, split_result[0])) == 0)
			{
				free_str_array(split_result);
				return (count);
			}
			free_str_array(split_result);
		}
		else
		{
			if ((ft_strcmp(str, input_array[count])) == 0)
				return (count);
		}
		count++;
	}
	return (-1);
}

// 환경변수 중 key=value 꼴을 띠지 않은 환경변수를 걸러냄.
char	**filter_env(char **input_array, char **free_array)
{
	int		from_count;
	int		add_count;
	char		**output_array;

	from_count = 0;
	add_count = 0;
	if (!(output_array = (char **)malloc(sizeof(char *)
	* (str_array_length(input_array) + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (input_array[from_count])
	{
		if (find_car(input_array[from_count], '=') != -1)
		{
			output_array[add_count] = ft_strdup(input_array[from_count]);
			add_count++;
		}
		from_count++;
	}
	output_array[add_count] = NULL;
	free_str_array(free_array);
	return (output_array);
}
