
#include "../includes/exec.h"

void	exec_file(int count)
{
	int	fd_file;

	if (g_lst->rdc_index[count][1] == 1)
	{
		if ((fd_file = open(g_lst->rdc_filetab[count],
		O_WRONLY | O_TRUNC | O_CREAT, 0644)) == -1)
			ft_error('\0', g_lst->rdc_filetab[count], NULL, 1);
	}
	if (g_lst->rdc_index[count][1] == 2)
	{
		if ((fd_file = open(g_lst->rdc_filetab[count],
		O_WRONLY | O_CREAT, 0644)) == -1)
			ft_error('\0', g_lst->rdc_filetab[count], NULL, 1);
	}
	close(fd_file);
}
