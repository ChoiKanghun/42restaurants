
#include "../includes/exec.h"

void	replace_var_in_array(char **output_array, char **add_array
	, int count_add, int index_from)
{
	free_str(&output_array[index_from]);
	output_array[index_from] = ft_strdup(add_array[count_add]);
}

int		add_var_in_array(char **output_array, char **add_array
	, int count_add, int index_add)
{
	output_array[index_add] = ft_strdup(add_array[count_add]);
	index_add++;
	return (index_add);
}

int		extend_array_with_var(char **output_array, char **add_array
	, int count_add, int index_add)
{
	int		index_from;
	char	**split_result;

	split_result = ft_split(add_array[count_add], '=');
	if ((index_from = search_in_array(output_array
	, split_result[0], '=')) >= 0)
		replace_var_in_array(output_array
		, add_array, count_add, index_from);
	else
		index_add = add_var_in_array(output_array
		, add_array, count_add, index_add);
	free_str_array(split_result);
	output_array[index_add] = NULL;
	return (index_add);
}

char	**extend_array_str(char **from_array, char *add_str, int from_len)
{
	int		count;
	char	**output_array;

	count = 0;
	if (!(output_array = (char **)malloc(sizeof(char *) * (from_len + 2))))
		ft_error('\0', "Malloc", NULL, 1);
	while (from_array[count])
	{
		output_array[count] = ft_strdup(from_array[count]);
		count++;
	}
	output_array[count] = ft_strdup(add_str);
	output_array[count + 1] = NULL;
	free_str_array(from_array);
	return (output_array);
}

char	**extend_array(char **from_array, char **add_array
	, int from_len, int add_len)
{
	int		count_from;
	int		count_add;
	int		index_add;
	char	**output_array;

	count_from = 0;
	count_add = 0;
	if (!(output_array = (char **)malloc(sizeof(char *)
	* (from_len + add_len + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (from_array[count_from])
	{
		output_array[count_from] = ft_strdup(from_array[count_from]);
		count_from++;
	}
	output_array[count_from] = NULL;
	index_add = count_from;
	while (add_array[count_add])
	{
		index_add = extend_array_with_var(output_array, add_array
		, count_add, index_add);
		count_add++;
	}
	free_str_array(from_array);
	return (output_array);
}
