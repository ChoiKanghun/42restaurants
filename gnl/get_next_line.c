/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/05/19 20:06:52 by kchoi             #+#    #+#             */
/*   Updated: 2020/05/19 20:07:03 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

char		*get_save(char *save)
{
	int		i;
	char	*dest;
	int		jndex;
	int		save_len;

	save_len = ft_strlen(save);
	i = 0;
	while (save[i] != '\0' && save[i] != '\n')
		i++;
	if (save[i] == '\0')
	{
		free(save);
		return (NULL);
	}
	i++;
	if (!(dest = (char *)malloc(sizeof(char) * save_len - i + 1)))
		return (NULL);
	jndex = 0;
	while (save[i])
		dest[jndex++] = save[i++];
	dest[jndex] = '\0';
	free(save);
	return (dest);
}

char		*get_line(char *save)
{
	int		i;
	char	*dest;
	int		dest_len;

	dest_len = 0;
	while (save[dest_len] && save[dest_len] != '\n')
		dest_len++;
	if (!(dest = (char *)malloc(sizeof(char) * dest_len + 1)))
		return (NULL);
	i = 0;
	while (i < dest_len)
	{
		dest[i] = save[i];
		i++;
	}
	dest[i] = '\0';
	return (dest);
}

int			get_next_line(int fd, char **line)
{
	int			reader;
	static char	*save;
	char		*buff;

	if (fd < 0 || !line || BUFFER_SIZE <= 0)
		return (-1);
	reader = 1;
	if (!(buff = (char *)malloc(sizeof(char) * BUFFER_SIZE + 1)))
		return (-1);
	while (reader != 0 && !if_newline_in_str(save))
	{
		if ((reader = read(fd, buff, BUFFER_SIZE)) < 0)
			return (-1);
		buff[reader] = '\0';
		if (!(save = ft_strjoin_custom(save, buff)))
			return (-1);
	}
	free(buff);
	*line = get_line(save);
	save = get_save(save);
	if (save == NULL)
		return (0);
	return (1);
}
