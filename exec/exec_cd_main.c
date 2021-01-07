
#include "../includes/exec.h"

void	update_oldpwd(int pwd_index, int oldpwd_index)
{
	char *old_pwd;
	char *add_pwd;

	if (pwd_index == -1 && g_pwd_check == 1)
		add_pwd = ft_strdup("");
	else
		add_pwd = ft_strdup(g_pwd_path);
	if (!(old_pwd = (char *)malloc(sizeof(char) * (ft_strlen(add_pwd) + 8))))
		ft_error('\0', "Malloc", NULL, 1);
	ft_strcpy(old_pwd, "OLDPWD=");
	ft_strcat(old_pwd, add_pwd);
	free_str(&g_global_env[oldpwd_index]);
	g_global_env[oldpwd_index] = old_pwd;
	free_str(&add_pwd);
}

void	update_pwd(int pwd_index, char *new_path)
{
	char *new_pwd;

	if (!(new_pwd = (char *)malloc(sizeof(char) * (ft_strlen(new_path) + 5))))
		ft_error('\0', "Malloc", NULL, 1);
	ft_strcpy(new_pwd, "PWD=");
	ft_strcat(new_pwd, new_path);
	if (pwd_index >= 0)
	{
		free_str(&g_global_env[pwd_index]);
		g_global_env[pwd_index] = new_pwd;
	}
	else
		g_global_env = extend_array_str(g_global_env
		, new_pwd, str_array_length(g_global_env));
}

void	update_env(char *new_path)
{
	int pwd_index;
	int oldpwd_index;

	pwd_index = search_in_array(g_global_env, "PWD", '=');
	oldpwd_index = search_in_array(g_global_env, "OLDPWD", '=');
	if (oldpwd_index != -1)
		update_oldpwd(pwd_index, oldpwd_index);
	if (pwd_index != -1)
		update_pwd(pwd_index, new_path);
	free_str(&g_pwd_path);
	g_pwd_path = ft_strdup(new_path);
	free_str(&new_path);
}

void	ft_cd(char **args)
{
	char	*path;
	int		result_chdir;

	if (str_array_length(args) > 1)
		ft_error('\0', "cd", "Too many arguments", 1);
	path = select_path(args[0]);
	if (path[ft_strlen(path) - 1] == '/' && ft_strlen(path) > 1)
		path[ft_strlen(path) - 1] = '\0';
	result_chdir = chdir(path);
	if (result_chdir == -1)
	{
		free_str(&path);
		ft_error('\0', "cd", "No such file or directory", 1);
	}
	else
		update_env(path);
}
