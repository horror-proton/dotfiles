import socket as _socket
import os as _os

INSTANCE_SIGNATURE = _os.getenv('HYPRLAND_INSTANCE_SIGNATURE')
if INSTANCE_SIGNATURE is None:
    exit(1)


def query(arg: bytes) -> bytes:
    with _socket.socket(_socket.AF_UNIX, _socket.SOCK_STREAM) as s:
        s.connect('/tmp/hypr/' + INSTANCE_SIGNATURE + '/.socket.sock')
        s.sendall(arg)
        data: bytes = b''
        while True:
            d = s.recv(1024)
            if len(d) == 0:
                break
            data += d
        s.close()
        return data


def socket2(s=_socket.socket(_socket.AF_UNIX,
                             _socket.SOCK_STREAM)) -> _socket.socket:
    s.connect('/tmp/hypr/' + INSTANCE_SIGNATURE + '/.socket2.sock')
    return s
