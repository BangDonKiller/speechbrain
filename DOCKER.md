# 建置 Docker Image 
docker build -t speechbrain:latest .

# 建置 Docker Container
docker run --gpus device=0 -d --rm -it --name speechbrain -v C:/Python/Master/speechbrain:/app -v D:/Dataset:/app/dataset speechbrain:latest

# 執行檔案位置
cd 到 recipes/VoxCeleb/SpeakerRec 底下，運行以下指令

模型訓練:
- 初次運行
  - python train_speaker_embeddings.py hparams/train_ecapa_tdnn.yaml --data_folder=/app/dataset/VoxCeleb2 --skip_prep=False --device=cuda:0
- 非初次運行
  - python train_speaker_embeddings.py hparams/train_ecapa_tdnn.yaml --data_folder=/app/dataset/VoxCeleb2 --skip_prep=True --device=cuda:0

模型驗證:
- 初次運行
  - python speaker_verification_cosine.py hparams/verification_ecapa.yaml --data_folder=/app/dataset/VoxCeleb2 --test_data_folder=/app/dataset/VoxCeleb1 --skip_prep=False --device=cuda:0
- 非初次運行
  - python speaker_verification_cosine.py hparams/verification_ecapa.yaml --data_folder=/app/dataset/VoxCeleb2 --test_data_folder=/app/dataset/VoxCeleb1 --skip_prep=True --device=cuda:0