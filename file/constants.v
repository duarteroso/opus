module file

pub const (
	op_false               = -1
	op_eof                 = -2
	op_hole                = -3
	op_eread               = -128
	op_efault              = -129
	op_eimpl               = -130
	op_einval              = -131
	op_enotformat          = -132
	op_ebadheader          = -133
	op_eversion            = -134
	op_enotaudio           = -135
	op_ebadpacket          = -136
	op_ebadlink            = -137
	op_enoseek             = -138
	op_ebadtimestamp       = -139
	opus_channel_count_max = 255
)

pub const (
	chunk = 4096
)