-module(smpp34pdu_bind_transmitter_resp).
-include("pdu.hrl").
-include("types.hrl").
-export([pack/1,unpack/1]).
-import(pdu_data, [cstring_to_bin/2]).
-import(pdu_data, [bin_to_cstring/2]).

-spec(pack/1 :: (bind_transmitter_resp()) -> binary()).
-spec(unpack/1 :: (binary()) -> bind_transmitter_resp()).
-spec(unpack_tlv_fields/2 :: (binary(), bind_transmitter_resp()) -> bind_transmitter_resp()).

pack(#bind_transmitter_resp{system_id=SystemId, 
		sc_interface_version=ScIntVersion}) ->

		L = [cstring_to_bin(SystemId, 16),
					   tlv:to_bin(?SC_INTERFACE_VERSION, ScIntVersion)],

		list_to_binary(L).


unpack(Bin0) ->
	{SystemId, Bin1} = bin_to_cstring(Bin0, 16),
	unpack_tlv_fields(Bin1, #bind_transmitter_resp{system_id=SystemId}).


unpack_tlv_fields(<<>>, Body) ->
	Body;
unpack_tlv_fields(<<?SC_INTERFACE_VERSION:16,Rest0/binary>>, Body) ->
	{Val, Rest1} = tlv:from_bin(?SC_INTERFACE_VERSION, Rest0),
	unpack_tlv_fields(Rest1, Body#bind_transmitter_resp{sc_interface_version=Val}).