

PredictImage=function(imagem,modelo,pickle,linhas){
	require(reticulate)
	use_python("/usr/bin/python3")
	require(keras)
	u=load_model_hdf5(modelo)
	source_python("classify_function.py")
	l1=prediction(u,pickle,imagem)
	l1=data.frame(l1)
	l1=l1[order(l1$probability,decreasing=TRUE),]
	if(nrow(l1)<linhas)
		print(l1)
	else
		print(l1[1:linhas,])
}
