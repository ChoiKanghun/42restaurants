#include "../includes/exec.h"

char	*transform_with_value(char *input_str)
{
	int		count;
	char	*output_str;

	count = 0;
	if (!(output_str = (char *)malloc(sizeof(char)
	* (ft_strlen(input_str) + 14))))
		ft_error('\0', "Malloc", NULL, 1);
	while (input_str[count] != '=')
		count++;
	ft_strcpy(output_str, "declare -x ");
	ft_strncat(output_str, input_str, count + 1);
	ft_strcat(output_str, "\"");
	output_str = transform_backslash(output_str,
	&input_str[find_car(input_str, '=') + 1]);
	ft_strcat(output_str, "\"");
	return (output_str);
}

char	*transform_without_value(char *input_str)
{
	char *output_str;

	if (!(output_str = (char *)malloc(sizeof(char)
	* (ft_strlen(input_str) + 12))))
		ft_error('\0', "Malloc", NULL, 1);
	ft_strcpy(output_str, "declare -x ");
	ft_strcat(output_str, input_str);
	return (output_str);
}

char	*transform_str(char *input_str)
{
	if (find_car(input_str, '=') != -1)
		return (transform_with_value(input_str));
	else
		return (transform_without_value(input_str));
}

char	**transform_array(char **input_array)
{
	int		count;
	char	**output_array;

	count = 0;
	if (!(output_array = (char **)malloc(sizeof(char *)
	* (str_array_length(input_array) + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (input_array[count])
	{
		output_array[count] = transform_str(input_array[count]);
		count++;
	}
	output_array[count] = NULL;
	free_str_array(input_array);
	return (output_array);
}

void	display_exported_env(void)
{
	char **displayable_env;

	displayable_env = duplicate_array(g_global_env, NULL, '\0');
	displayable_env = sort_array(displayable_env);
	displayable_env = transform_array(displayable_env);
	display_str_array(displayable_env);
	free_str_array(displayable_env);
}
