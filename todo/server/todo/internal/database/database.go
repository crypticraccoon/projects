package database

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v5/pgxpool"
	"server/internal/confs"
)

type Database struct {
	context context.Context
	conn    *pgxpool.Pool
}

func NewDatabase(ctx context.Context) *Database {
	return &Database{
		context: ctx,
	}
}

func (d *Database) Connect(conf *confs.Database) error {
	connString := fmt.Sprintf(
		"postgres://%s:%s@%s/%s",
		conf.User,
		conf.Password,
		conf.Host,
		conf.Database,
	)
	println(connString);
	pgxPoolConfig, err := pgxpool.ParseConfig(connString)
	if err != nil {
		return err
	}
	pgxPoolConfig.MinIdleConns = int32(conf.MinIdleConns)

	conPool, err := pgxpool.NewWithConfig(d.context, pgxPoolConfig)
	if err != nil {
		return err
	}

	if err := conPool.Ping(d.context); err != nil {
		return err
	}

	println("Database successfully pinged")

	d.conn = conPool
	return nil
}

func (d *Database) GetDatabase() *pgxpool.Pool {
	return d.conn
}

func (d *Database) Close() {
	println("database shutdown")
	d.conn.Close()
}
