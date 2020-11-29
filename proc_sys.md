# proc

| 目录      | 内容                                          |
| --------- | --------------------------------------------- |
| limits    | 实际的资源限制                                |
| maps      | 映射的内存区域                                |
| sched     | CPU 调度器的各种统计                          |
| schedstat | CPU 运行时间、延时和时间分片                  |
| smaps     | 映射内存区域的使用统计                        |
| stat      | 进程状态和统计，包括总的 CPU 和内存的使用情况 |
| statm     | 以页为单位的内存使用总结                      |
| status    | stat 和 statm 的信息，用户可读                |
| task      | 每个任务的统计目录                            |

# sys

## 查看 `cpu` 的缓存

cpu0

```sh
grep . /sys/devices/system/cpu/cpu0/cache/index*/level
grep . /sys/devices/system/cpu/cpu0/cache/index*/size
```
