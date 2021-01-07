/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   manage_env.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:18:31 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:18:36 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

char	*read_from_fd(int read_end)
{
	int		ret;
	char	buf[101];
	char	*output_str;

	output_str = NULL;
	while ((ret = read(read_end, buf, 100)) > 0)
	{
		buf[ret] = '\0';
		output_str = ft_join(output_str, buf
		, ft_len(output_str), ft_len(buf));
		if (ret < 100)
			break ;
	}
	return (output_str);
}

char	*get_env_value(char *var)
{
	int		count;
	char	*env_value;
	char	**split_result;

	count = 0;
	while (g_global_env[count])
	{
		split_result = ft_split(g_global_env[count], '=');
		if (strcmp(split_result[0], var) == 0)
		{
			env_value = ft_strdup(split_result[1]);
			free_str_array(split_result);
			return (env_value);
		}
		free_str_array(split_result);
		count++;
	}
	return (NULL);
}

void	send_env(int write_pend, int write_pwdend)
{
	int count;

	count = 0;
	while (g_global_env[count])
	{
		write(write_pend, g_global_env[count]
		, ft_strlen(g_global_env[count]));
		write(write_pend, "\n", 1);
		count++;
	}
	write(write_pwdend, g_pwd_path, ft_strlen(g_pwd_path));
	close(write_pend);
	close(write_pwdend);
}

void	receive_env(int read_pend, int read_pwdend)
{
	char *str_env;
	char *new_path;
	char **tab_env;

	str_env = read_from_fd(read_pend);
	if (str_env)
	{
		tab_env = ft_split(str_env, '\n');
		g_global_env = duplicate_array(tab_env, g_global_env, '\0');
		free_str(&str_env);
		free_str_array(tab_env);
	}
	new_path = read_from_fd(read_pwdend);
	if (new_path)
	{
		if (ft_strcmp(new_path, g_pwd_path) != 0)
			g_pwd_check = 0;
		free_str(&g_pwd_path);
		g_pwd_path = ft_strdup(new_path);
		free_str(&new_path);
		chdir(g_pwd_path);
	}
	close(read_pwdend);
}
