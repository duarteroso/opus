module test

import file

const mono_channels = 1
const stereo_channels = 2
const duration = 7.0
const sample_rate = 48_000
const file_size = 348_481

fn test_opus_open_mono() ! {
	mut decoder := file.create_decoder()
	//
	decoder.open('./data/opus_mono.opus')!
	assert decoder.is_opened()
	//
	assert decoder.is_stereo() == false
	assert decoder.sample_rate() == test.sample_rate
	assert decoder.bitrate()! == 104_136
	assert decoder.channels() == test.mono_channels
	assert decoder.duration()! == test.duration
	assert decoder.size() == test.file_size
	//
	decoder.seek(1)!
	//
	mut buffer := []i16{len: file.chunk}
	mut bytes := decoder.read(mut buffer)!
	//
	buffer = []i16{len: int(decoder.size())}
	bytes = decoder.read_all(mut buffer)!
	//
	decoder.close()!
	assert decoder.is_opened() == false
}

fn test_opus_open_stereo() ! {
	mut decoder := file.create_decoder()
	//
	decoder.open('./data/opus_stereo.opus')!
	assert decoder.is_opened()
	//
	assert decoder.is_stereo() == true
	assert decoder.sample_rate() == test.sample_rate
	assert decoder.bitrate()! == 108_572
	assert decoder.channels() == test.stereo_channels
	assert decoder.duration()! == test.duration
	assert decoder.size() == test.file_size * test.stereo_channels
	//
	decoder.seek(1)!
	//
	mut buffer := []i16{len: file.chunk}
	mut bytes := decoder.read(mut buffer)!
	//
	buffer = []i16{len: int(decoder.size())}
	bytes = decoder.read_all(mut buffer)!
	//
	decoder.close()!
	assert decoder.is_opened() == false
}
