
#include "../includes/parsing.h"
#include "../includes/exec.h"

/*
** ger_redir(stock)으로 '>', '>>', '<'을 처리함.
** clear_stock_rd(stock)은 stock의 rd이후 부분을 모두
** space로 치환시켜버림.
** pipe는 pipe가 없는 경우 0.
*/

static t_cont	get_content_lst(char *stock, int pipe, int i, int j)
{
	t_cont	cont;
	char	**content;

	cont = get_redir(stock);
	stock = clear_stock_rd(stock);
	content = split_plus(stock, ' ');
	cont.raw = duplicate_array(content, NULL, '\0');
	if (content[0] && content[0][0])
		cont.cmd = ft_strdup(content[0]);
	else
		cont.cmd = NULL;
	i = 1;
	while (content[i])
		i++;
	if (!(cont.arg = malloc(sizeof(char*) * i + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	i = 1;
	j = 0;
	if (content[0])
		while (content[i])
			cont.arg[j++] = ft_strdup(content[i++]);
	cont.arg[j] = NULL;
	cont.pipe = pipe;
	free_str_array(content);
	return (cont);
}

static void		new_elem_lst_2(t_list *elem)
{
	t_list	*tmp;

	if (is_empty_lst())
		g_lst = elem;
	else
	{
		tmp = g_lst;
		while (tmp->next)
			tmp = tmp->next;
		tmp->next = elem;
	}
}

static void		new_elem_lst(char *stock_elem, int pipe)
{
	t_list	*elem;
	t_cont	cont;
	int		i;
	int		j;

	i = 0;
	j = 0;
	if (!(elem = malloc(sizeof(t_list))))
		ft_error('\0', "Malloc", NULL, 1);
	cont = get_content_lst(stock_elem, pipe, i, j);
	elem->cmd = cont.cmd;
	elem->arg = cont.arg;
	elem->raw = cont.raw;
	elem->rdc_type = cont.rdc_type;
	elem->rdo_type = cont.rdo_type;
	elem->rdc_filetab = cont.rdc_filetab;
	elem->rdo_filetab = cont.rdo_filetab;
	elem->rdc_filename = cont.rdc_filename;
	elem->rdo_filename = cont.rdo_filename;
	elem->rdc_index = cont.rdc_index;
	elem->rdo_index = cont.rdo_index;
	elem->pipe = pipe;
	elem->next = NULL;
	new_elem_lst_2(elem);
}

static void		list_pipe(char *stock_elem_piped)
{
	int		i;
	char	**pipe_sep;

	i = 0;
	pipe_sep = split_plus(stock_elem_piped, '|');
	free_str(&stock_elem_piped);
	while (pipe_sep[i] && is_only_space(pipe_sep[i]))
	{
		if (pipe_sep[i + 1] != NULL)
			new_elem_lst(pipe_sep[i], 1);
		else
			new_elem_lst(pipe_sep[i], 0);
		i++;
	}
	free_str_array(pipe_sep);
}

/*
**  is_only_space(char *str)은 str[i++]동안 ' '로만
**  구성되었는지를 확인.
**  ' '만 있다면 0을 리턴. 하나라도 다른 문자가 있으면
**  1을 리턴.
**  반대로 is_pipe는 pipe가 하나라도 있으면 1, 아니면 0
**  new_elem_lst는 g_lst 맨 뒤에 new_lst를 붙임.
**  
**  is_pipe가 true인 경우 new_elem_lst로 붙이는 구조체의
**  pipe = 1이 들어감. 나머지는 차이 없음.
*/

void			list_it(char **stock)
{
	int i;

	i = 0;
	while (stock[i] && is_only_space(stock[i]))
	{
		if (!is_pipe(stock[i]))
		{
			new_elem_lst(stock[i], 0);
			free_str(&stock[i]);
		}
		else
			list_pipe(stock[i]);
		i++;
	}
}
