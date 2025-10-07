# CameraSmoothFollow.gd
extends Camera3D

# Alvo que a câmera deve seguir (o nó do jogador).
# A palavra-chave 'export' faz com que a variável apareça no editor do Godot,
# permitindo que você arraste e solte o nó do jogador aqui.
@export var target: Node3D

# A suavidade do movimento.
# Valores menores farão a câmera seguir mais lentamente e suavemente.
# Valores maiores farão a câmera seguir de forma mais rígida e rápida.
# Um bom valor para começar é entre 1 e 5.
@export var smoothness: float = 2.0

# A distância fixa que a câmera manterá do jogador.
# Você pode ajustar este valor no editor para definir o zoom da câmera.
@export var offset: Vector3 = Vector3(0, 5, 10)

func _process(delta: float) -> void:
	# Verifica se o alvo (target) foi definido.
	# Sem isso, o jogo travaria se você esquecesse de atribuir o jogador.
	if not target:
		return

	# 1. CALCULAR A POSIÇÃO DESEJADA
	# A posição ideal para a câmera é a posição do jogador mais o deslocamento (offset).
	var target_position = target.global_position + offset

	# 2. INTERPOLAR SUAVEMENTE A POSIÇÃO ATUAL ATÉ A POSIÇÃO DESEJADA
	# A função 'lerp' calcula um ponto entre dois outros pontos.
	# 'global_position' é a posição atual da câmera.
	# 'target_position' é onde queremos que a câmera esteja.
	# 'smoothness * delta' é o fator de interpolação. Ele determina
	# "quão longe" na direção do alvo a câmera se moverá neste frame.
	# O uso de 'delta' garante que o movimento seja consistente,
	# independentemente da taxa de quadros (FPS) do jogo.
	global_position = global_position.lerp(target_position, smoothness * delta)

	# 3. FAZER A CÂMERA OLHAR PARA O JOGADOR
	# Isso garante que, mesmo durante o movimento, a câmera esteja sempre
	# apontada para o jogador, mantendo-o no centro do quadro.
	#look_at(target.global_position)
