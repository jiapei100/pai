#mpi cntk prepare
echo "Prepare for the mpi example!"

function mpi_cntk_prepare_data(){

    #download data
	echo "Downloading mpi cntk data, waiting..."
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.mapping
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.test
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.test.ctf
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.test.txt
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train-dev-1-21
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train-dev-1-21.ctf
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train-dev-1-21.txt
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train-dev-20-21
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train-dev-20-21.ctf
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/cmudict-0.7b.train-dev-20-21.txt
    wget https://github.com/Microsoft/CNTK/raw/master/Examples/SequenceToSequence/CMUDict/Data/tiny.ctf

    #upload data to HDFS
	echo "Uploading mpi cntk data, waiting..."
    hdfs dfs -put cmudict-0.7b hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.mapping hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.test hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.test.ctf hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.test.txt hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train-dev-1-21 hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train-dev-1-21.ctf hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train-dev-1-21.txt hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train-dev-20-21 hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train-dev-20-21.ctf hdfs://$1/examples/cntk/data
    hdfs dfs -put cmudict-0.7b.train-dev-20-21.txt hdfs://$1/examples/cntk/data
    hdfs dfs -put tiny.ctf hdfs://$1/examples/cntk/data
}


function mpi_cntk_prepare_code(){
    #code
    #G2P.cntk
	echo "Downloading mpi cntk code, waiting..."
    wget https://github.com/Microsoft/pai/raw/master/examples/mpi/cntk-mpi.sh

    #upload code to HDFS
	echo "Uploading mpi cntk code, waiting..."
    hdfs dfs -put cntk-mpi.sh hdfs://$1/examples/mpi/cntk/code
}

if [ $# != 1 ]; then
    echo "You must input hdfs socket as the only parameter! Or you cannot run this script correctly!"
    exit 1
fi

#make directory on HDFS
echo "Make mpi cntk directory, waiting..."
hdfs dfs -mkdir -p hdfs://$1/examples/mpi/cntk/code
hdfs dfs -mkdir -p hdfs://$1/examples/mpi/cntk/output
hdfs dfs -mkdir -p hdfs://$1/examples/cntk/data

hdfs dfs -test -e hdfs://$1/examples/mpi/cntk/code/*
if [ $? -eq 0 ] ;then
    echo "Code exists on HDFS!"
else
    mpi_cntk_prepare_code $1
    echo "Have prepared code!"
fi

hdfs dfs -test -e hdfs://$1/examples/cntk/data/*
if [ $? -eq 0 ] ;then
    echo "Data exists on HDFS!"
else
    mpi_cntk_prepare_data $1
    echo "Have prepared data"
fi

#delete the files
rm cntk-mpi.sh* G2P.cntk* cmudict* tiny.ctf*
echo "Removed local mpi cntk code and data succeeded!"

#mpi tensorflow cifar-10 prepare
function mpi_tensorflow_prepare_data(){
    #download the data
    wget http://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz && tar zxvf cifar-10-python.tar.gz && rm cifar-10-python.tar.gz

    #upload the data to HDFS
    echo "Uploading cifar-10 data, waiting..."
    for i in `ls cifar-10-batches-py`
    do
        hdfs dfs -put cifar-10-batches-py/$i hdfs://$1/examples/tensorflow/distributed-cifar-10/data
    done
}

function mpi_tensorflow_prepare_code(){
    #download the code
    git clone -b tf_benchmark_stage https://github.com/tensorflow/benchmarks.git

    #upload the code to HDFS
    echo "Uploading benchmarks code, waiting..."
    hdfs dfs -put benchmarks/ hdfs://$1/examples/tensorflow/distributed-cifar-10/code
}

echo "Make mpi tensorflow directory, waiting..."
hdfs dfs -mkdir -p hdfs://$1/examples/mpi/tensorflow/output
hdfs dfs -mkdir -p hdfs://$1/examples/tensorflow/distributed-cifar-10/code
hdfs dfs -mkdir -p hdfs://$1/examples/tensorflow/distributed-cifar-10/data

hdfs dfs -test -e hdfs://$1/examples/tensorflow/distributed-cifar-10/code/*
if [ $? -eq 0 ] ;then
    echo "Code exists on HDFS!"
else
    mpi_tensorflow_prepare_code $1
    echo "Have prepared code!"
fi

hdfs dfs -test -e hdfs://$1/examples/tensorflow/distributed-cifar-10/data/*
if [ $? -eq 0 ] ;then
    echo "Data exists on HDFS!"
else
    mpi_tensorflow_prepare_data $1
    echo "Have prepared data"
fi

rm -r cifar-10-batches-py*/ benchmarks*/
echo "Removed local cifar-10 code and data succeeded!"
echo "Prepare mpi example based on horovod and tensorflow done!"
