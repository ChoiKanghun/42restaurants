/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:16:40 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:16:41 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

char	*ft_join(char *str_1, char *str_2, int len_1, int len_2)
{
	int		cmp;
	char	*output_str;

	if (!(output_str = (char *)malloc(sizeof(char) * (len_1 + len_2 + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	if (output_str == NULL)
		return (NULL);
	cmp = 0;
	if (str_1)
		while (str_1[cmp])
		{
			output_str[cmp] = str_1[cmp];
			cmp++;
		}
	cmp = 0;
	while (str_2[cmp])
	{
		output_str[cmp + len_1] = str_2[cmp];
		cmp++;
	}
	output_str[cmp + len_1] = '\0';
	free_str(&str_1);
	return (output_str);
}

int		ft_error_input(int fd, char **line, int *pass, char **str)
{
	char	check_str[1];

	*pass = 0;
	*str = NULL;
	if (fd < 0 || !line || read(fd, check_str, 0) == -1)
		return (-1);
	return (1);
}

int		ft_id(char *str)
{
	int cmp;

	cmp = ft_search(str);
	if (cmp == -1)
		cmp = ft_len(str);
	return (cmp);
}

int		get_next_line(int fd, char **line)
{
	static char	*str;
	int			ret;
	char		buf[101];
	int			pass;

	if (ft_error_input(fd, line, &pass, &str) == -1)
		return (-1);
	while (((ret = read(fd, buf, 100)) > 0) || (ret > -1 && str))
	{
		pass = 1;
		buf[ret] = '\0';
		str = ft_join(str, buf, ft_len(str), ft_len(buf));
		if (ft_search(str) != -1)
			break ;
	}
	if (str && str[0] && ft_search(str) != -1)
	{
		*line = ft_dup(str, ft_id(str), NULL);
		str = ft_dup(&str[ft_id(str) + 1], ft_len(&str[ft_id(str) + 1]), str);
		free(str);
		return (1);
	}
	*line = ft_dup(str, ft_id(str), NULL);
	str = ft_settle(str, pass);
	return (0);
}
