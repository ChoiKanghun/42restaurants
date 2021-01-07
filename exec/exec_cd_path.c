
#include "../includes/exec.h"

char	*add_dir(char *path, char *input_path, int dir_length)
{
	int		add_char;
	char	*complex_path;

	add_char = 0;
	if (ft_strlen(path) > 1)
		add_char = 1;
	if (!(complex_path = (char *)malloc(sizeof(char) * (ft_strlen(path)
	+ dir_length + add_char + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	ft_strcpy(complex_path, path);
	if (ft_strlen(path) > 1)
		ft_strcat(complex_path, "/");
	ft_strncat(complex_path, input_path, dir_length);
	free_str(&path);
	path = ft_strdup(complex_path);
	free_str(&complex_path);
	return (path);
}

char	*add_dir_to_path(char *input_path, char *path, int *count)
{
	int	dir_length;

	if ((dir_length = find_car(input_path, '/')) == -1)
		dir_length = ft_strlen(input_path);
	else if (dir_length == 0)
		dir_length++;
	path = add_dir(path, input_path, dir_length);
	*count += (dir_length - 1);
	return (path);
}

char	*create_path(char *input_path, char *path)
{
	int count;
	int	path_len;

	count = 0;
	while (input_path[count])
	{
		path_len = ft_strlen(path);
		if (count != 0 && input_path[count] == '.' && input_path[count - 1]
		== '.' && (input_path[count + 1] == '/' || !(input_path[count + 1])))
		{
			while (path_len > 1 && path[path_len] != '/')
				path_len--;
			path[path_len] = '\0';
		}
		else if ((input_path[count] != '.'
		&& input_path[count] != '/' && input_path[count] != '~')
		|| (input_path[count] == '.' && input_path[count + 1] == '.'
		&& input_path[count + 2] == '.'))
			path = add_dir_to_path(&input_path[count], path, &count);
		count++;
	}
	return (path);
}

char	*relative_path(char *input_path)
{
	char *path;

	if (input_path[0] == '~')
		path = get_env_value("HOME");
	else
		path = ft_strdup(g_pwd_path);
	return (create_path(input_path, path));
}

char	*select_path(char *input_path)
{
	char *output_path;

	if (input_path == NULL)
		output_path = get_env_value("HOME");
	else if ((((input_path[0] == '.' && !(input_path[1]))
			|| (input_path[0] == '.' && input_path[1] == '/')))
			|| (input_path[0] == '.' && input_path[1] == '.'
			&& (input_path[2] == '/' || !(input_path[2])))
			|| ((input_path[0] == '~' && !(input_path[1]))
			|| (input_path[0] == '~' && input_path[1] == '/')))
		output_path = relative_path(input_path);
	else if (input_path[0] == '/')
		output_path = ft_strdup(input_path);
	else
		output_path = relative_path(input_path);
	return (output_path);
}
