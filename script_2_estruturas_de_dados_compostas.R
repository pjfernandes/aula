#vetores
x<-seq(1,10,2)
c<-seq(5,10,length=30)
y<-c(1,2,3,4,5)
z<-1:10
a<-"blablabla"
b<-c("a","b","c")
d<-rep(c(0,1,2),times=10)

y[1]
y[c(1,2)]
y[1]<-2

ls() #comando para listar os objetos
rm(a) #remote o objeto a
rm(list=ls()) #remove tudo

#matrizes
x<-1:9
m<-matrix(x,ncol=3,nrow=3)
m2<-matrix(x,ncol=3,nrow=3,byrow=T)
m+m2
t(m^m2)
m[1,1]
m[,1]
m[c(1,2),]
colSums(m)

#Determinante da matriz
matriz<-matrix(c(4,5,-3, 2,1,0, 3,-1,1), ncol=3, nrow=3, byrow=T)
det(matriz)

#matriz_inversa
m<-matrix(c(4,1,2,0),nrow=2,ncol=2,byrow=T)
solve(matriz)

#lista
lista<-list(x,m,rnorm(10))
pes<-list(idade=41,nome="James Bond",notas=c(98,95,100))
lista[1]
lista[[2]]
is.list(lista[1])
is.vector(lista[[2]]) 

#Data Frame
df<-data.frame(nome=c("João","Bruno","Roberto"),indice=1:3)
df[,2]
df[1,2]
df$indice
df$indice[1]

df<-read.csv("https://raw.githubusercontent.com/pjfernandes/curso_r/master/aula_2/samples.csv", h=T, sep=";")
head(df)
names(tab)
